import cv2
from skimage.measure import compare_ssim
import imutils
from selenium import webdriver
import subprocess
import os


def screenshot(driver, url, filename):
    # ローカルホスト指定はホストマシンのIPに書き換える
    if "localhost" in url:
        host_addr = subprocess.run(["ip route | awk 'NR==1 {print $3}'"], stdout=subprocess.PIPE,
                                   stderr=subprocess.PIPE, shell=True).stdout.decode("utf8").rstrip('\n')
        url = url.replace("localhost", host_addr)
    print(url)
    driver.get(url)
    driver.save_screenshot(filename)


def diff_images(base_image_path, diff_image_path):
    """
    referer to https://www.pyimagesearch.com/2017/06/19/image-difference-with-opencv-and-python/
    :param base_image_path:
    :param diff_image_path:
    :return:
    """
    # load the two input images
    base_image = cv2.imread(base_image_path)
    diff_image = cv2.imread(diff_image_path)

    # convert the images to grayscale
    grayA = cv2.cvtColor(base_image, cv2.COLOR_BGR2GRAY)
    grayB = cv2.cvtColor(diff_image, cv2.COLOR_BGR2GRAY)

    (score, sub) = compare_ssim(grayA, grayB, full=True)
    sub = (sub * 255).astype("uint8")
    print("SSIM: {}".format(score))
    thresh = cv2.threshold(sub, 0, 255, cv2.THRESH_BINARY_INV | cv2.THRESH_OTSU)[1]
    cnts = cv2.findContours(thresh.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    cnts = imutils.grab_contours(cnts)

    for c in cnts:
        # compute the bounding box of the contour and then draw the
        # bounding box on both input images to represent where the two
        # images differ
        (x, y, w, h) = cv2.boundingRect(c)
        cv2.rectangle(base_image, (x, y), (x + w, y + h), (0, 0, 255), 2)
        cv2.rectangle(diff_image, (x, y), (x + w, y + h), (0, 0, 255), 2)
    cv2.imwrite("/app/dist/base.png", base_image)
    cv2.imwrite("/app/dist/diff.png", diff_image)
    cv2.imwrite("/app/dist/sub.png", sub)


def main():
    options = webdriver.ChromeOptions()
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    options.add_argument('--hide-scrollbars')
    options.add_argument('--window-size={}'.format(os.environ['WINDOW_SIZE']))

    driver = webdriver.Chrome(options=options)
    screenshot(driver, os.environ['BASE_URL'], "/app/dist/base.png")
    screenshot(driver, os.environ['DIFF_URL'], "/app/dist/diff.png")
    diff_images("/app/dist/base.png", "/app/dist/diff.png")
    driver.close()
    driver.quit()


if __name__ == '__main__':
    main()
