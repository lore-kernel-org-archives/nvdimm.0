Received: from mail1.bemta32.messagelabs.com (mail1.bemta32.messagelabs.com [195.245.230.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002417C
	for <nvdimm@lists.linux.dev>; Thu,  8 Sep 2022 01:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
	s=170520fj; t=1662601050; i=@fujitsu.com;
	bh=bh6uYGhxg0GUGg2dtG1uVy9/vMsVBY0RXkNW7/hrpvk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=o0qA0dodm+PWt36LanV5aIqRefagTVbcw8u/EEH80bxXWQZh7sBn/61FnAO2Srjpg
	 80aMlq7ZExv/WshJckW2j8YqPKUPFsuZT23/PEgbnwdGK+L7RepFJBp9TEj4zKl4Fv
	 x9Bd1+7q+fcUq64qkDxEI7JHhxnbnSYkSJypVjBGLUi9h3YpFI2Rd9FoGA4ZFh1/lm
	 /eMmY5TNVLaHsTB7UPkRdhVtD7rIcZmFKV+/73kdqtG6IUiW2prGDt/v98kfTwjNDS
	 vsQbh03RbK4fvu2CbEX2o4gQU5J32tCeZPmLLJcgQAc06TMY53N+HJ8bOY4ZwIUvXk
	 /fRXzDGqS3vkw==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRWlGSWpSXmKPExsViZ8MxSTfKXTL
  Z4L2Bxcoff1gdGD1ebJ7JGMAYxZqZl5RfkcCasWrtd9aCJSwV05ZuYmxgPMHcxcjFISRwkVHi
  xZtWVgjnCJPEh9Y7UJkjjBLN/58xdTFycrAJaEjca7nJCGKLCMhIXLgziRXEZhZQkzi2ejkzi
  C0sYCXxa/8eMJtFQEVi65ZedhCbV8BRYuba6WC2hICCxJSH75kh4oISJ2c+YYGYIyFx8MULZo
  gaRYkjnX9ZIOwKicbph5ggbDWJq+c2MU9g5J+FpH0WkvYFjEyrGK2SijLTM0pyEzNzdA0NDHQ
  NDU11gaSRsV5ilW6iXmqpbnlqcYmuoV5iebFeanGxXnFlbnJOil5easkmRmBQphQzVO9g/N/7
  U+8QoyQHk5Ior7GuZLIQX1J+SmVGYnFGfFFpTmrxIUYZDg4lCd6bzkA5waLU9NSKtMwcYITAp
  CU4eJREeL+5AKV5iwsSc4sz0yFSpxgVpcR5c22BEgIgiYzSPLg2WFReYpSVEuZlZGBgEOIpSC
  3KzSxBlX/FKM7BqCTMewVkO09mXgnc9FdAi5mAFm8NFAdZXJKIkJJqYFrQeeiGXtzb1/uvKgm
  GPbimWy8m0G93cp1+4xSpTxnmJ6K4T68+fKYrzfv53xm1m84+92ZqOqqTUP1sqW+Tbdau+84/
  J7nZ7ZwtYHOK5Utj6O9TjTfiCu+svejKfsizeubhiUdu1hzPEFbmr29skCpTVVI+/LLR6teJK
  /zlKv0P/54/vOhO8RWXSdJ5LzN+dK3l7eqw/+yty/mi1Kh5xmK2+6XbHts823ziYcM1LeP4uT
  WbfwZ/sHRvqE97e/D0UaEw+ynWd3MP3e31u8m6aFPygozGRcrmqiu47vfKH3v0U+pPSHCext7
  4+CgrbcOji7Z+DGuQ02Ds1byyP7ay2SAtYo/vhLdtCbrJ7Y+d25RYijMSDbWYi4oTAVX0kU1F
  AwAA
X-Env-Sender: lizhijian@fujitsu.com
X-Msg-Ref: server-4.tower-587.messagelabs.com!1662601049!389269!1
X-Originating-IP: [62.60.8.146]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received:
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 1609 invoked from network); 8 Sep 2022 01:37:29 -0000
Received: from unknown (HELO n03ukasimr02.n03.fujitsu.local) (62.60.8.146)
  by server-4.tower-587.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 8 Sep 2022 01:37:29 -0000
Received: from n03ukasimr02.n03.fujitsu.local (localhost [127.0.0.1])
	by n03ukasimr02.n03.fujitsu.local (Postfix) with ESMTP id 9E6C21000C2
	for <nvdimm@lists.linux.dev>; Thu,  8 Sep 2022 02:37:29 +0100 (BST)
Received: from R01UKEXCASM121.r01.fujitsu.local (R01UKEXCASM121 [10.183.43.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by n03ukasimr02.n03.fujitsu.local (Postfix) with ESMTPS id 90C6D1000C1
	for <nvdimm@lists.linux.dev>; Thu,  8 Sep 2022 02:37:29 +0100 (BST)
Received: from cb62f33e06a5.g08.fujitsu.local (10.167.226.45) by
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Thu, 8 Sep 2022 02:37:27 +0100
From: Li Zhijian <lizhijian@fujitsu.com>
To: <nvdimm@lists.linux.dev>
CC: Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH] README.md: Remove deprecated ND_BLK
Date: Thu, 8 Sep 2022 01:36:22 +0000
Message-ID: <1662600982-7-1-git-send-email-lizhijian@fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.45]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173)
X-Virus-Scanned: ClamAV using ClamSMTP

ND_BLK kconfig was removed by kernel commit
f8669f1d6a86 ("nvdimm/blk: Delete the block-aperture window driver")

Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 README.md | 1 -
 1 file changed, 1 deletion(-)

diff --git a/README.md b/README.md
index e5c4940..d0a28de 100644
--- a/README.md
+++ b/README.md
@@ -66,7 +66,6 @@ loaded.  To build and install nfit_test.ko:
    CONFIG_ZONE_DEVICE=y
    CONFIG_LIBNVDIMM=m
    CONFIG_BLK_DEV_PMEM=m
-   CONFIG_ND_BLK=m
    CONFIG_BTT=y
    CONFIG_NVDIMM_PFN=y
    CONFIG_NVDIMM_DAX=y
-- 
1.8.3.1

