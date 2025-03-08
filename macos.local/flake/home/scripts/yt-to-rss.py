import requests
from bs4 import BeautifulSoup
import sys

channel_link = sys.argv[1]

response = requests.get(channel_link)
soup = BeautifulSoup(response.content, "html.parser")
rss_link = soup.find("link", title="RSS")
rss_url = rss_link.get("href")

print(rss_url)
