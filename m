Received: from mail3.bemta32.messagelabs.com (mail3.bemta32.messagelabs.com [195.245.230.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A134408
	for <nvdimm@lists.linux.dev>; Thu,  2 Feb 2023 12:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
	s=170520fj; t=1675341243; i=@fujitsu.com;
	bh=J3fIpU6tmL9uRL1TDcHv8hQsLLABkSDshjR6iG+9dYE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=mabZLUorSxmuOO5995L+EDuu79jEgyRZGmhHqwyEgoMP1ovKN4dRS0it5oG9fWqVK
	 9IMrsuRnxKG2dzCX8qi+Lc+pBbtk0vvEsoCw9VRtXxOjBx6WAalrxa/vqhk+oot//d
	 H7iyehNpdjgXZZLyvI4nmJZpIlCLat3eBCtV0N4J++wdqKaOFSciX7yV6/xDgFeGX7
	 EjxIGDEeWmjdCim6DDGbZfRPkYDGoBqCtdQFX9xIxu6wqR9NnhfpjLU2rb4IkaKNEz
	 DhQYaqwulQqrW71r6hEUBOpoxVM4Uzu/TgTYIgNmBs71ZXps9PKqvvwxqjoblI/PVK
	 Cc1OsHrlUdn5g==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRWlGSWpSXmKPExsViZ8ORpLtr7e1
  kg/l/2S3mrF/DZjF96gVGiy3H7jFaXH7CZ7Fn70kWi11/drBbrPzxh9WB3ePUIgmPxXteMnls
  WtXJ5nFixm8WjxebZzJ6fN4kF8AWxZqZl5RfkcCa0bP2CWPBE5aKxe1nGRsYm1i6GLk4hAQ2M
  kp8ud7HCOEsZZI49uAHK4Szl1GiZ+JT9i5GTg42AR2JCwv+soLYIgLREm8eTgCLMws0M0pcu+
  EPYgsLuEu8W36VGcRmEVCRmDLlEVg9r4CLxOYFP8DiEgIKElMevmeGiAtKnJz5hAVijoTEwRc
  vgOIcQDVKEjO74yHKKyVaP/xigbDVJK6e28Q8gZF/FpLuWUi6FzAyrWI0K04tKkst0jW00Esq
  ykzPKMlNzMzRS6zSTdRLLdUtTy0u0TXUSywv1kstLtYrrsxNzknRy0st2cQIDPqUYrZ3OxhX9
  f3VO8QoycGkJMqb1387WYgvKT+lMiOxOCO+qDQntfgQowwHh5IE77Y1QDnBotT01Iq0zBxgBM
  KkJTh4lER4axcBpXmLCxJzizPTIVKnGBWlxHlDQfoEQBIZpXlwbbCov8QoKyXMy8jAwCDEU5B
  alJtZgir/ilGcg1FJmPfXCqApPJl5JXDTXwEtZgJafNf6JsjikkSElFQDU9n0Slcl+VDBmu9C
  hvNblYUn9z98Kf/sZ3fgyWIO3zUyek7NassjChk3/pzzKfK9hdfGN78XBzY1ydrbayVdTTvEO
  63mxL8Xjxd3Xuw+dro+L2/d9CMaab+u7WjlrRVztN9VUyQ499VFzp63V565vG1sM2ZLPPJoYw
  ZLwwLhKXF7M1S3/jqi/0xayOrpxQeKL22uy9+PdJshq7HIgVnn0hGrpKsBB3Q+WDmJCGxqOam
  VP7dUeg9P2eQyl3MynsJqt196XXkVYuI7f8eJy+uTXzi1/txsGTynweT9tf5on1fxj42f3tie
  d/WPuc5V7r3NOv1Pn537e0JGZGnXbtftKz3KTyVdCyzf0qEyx33vSSWW4oxEQy3mouJEAOzZz
  eB1AwAA
X-Env-Sender: ruansy.fnst@fujitsu.com
X-Msg-Ref: server-22.tower-585.messagelabs.com!1675341241!62076!1
X-Originating-IP: [62.60.8.98]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received:
X-StarScan-Version: 9.102.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 15427 invoked from network); 2 Feb 2023 12:34:02 -0000
Received: from unknown (HELO n03ukasimr03.n03.fujitsu.local) (62.60.8.98)
  by server-22.tower-585.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 2 Feb 2023 12:34:02 -0000
Received: from n03ukasimr03.n03.fujitsu.local (localhost [127.0.0.1])
	by n03ukasimr03.n03.fujitsu.local (Postfix) with ESMTP id A02B71AE;
	Thu,  2 Feb 2023 12:34:01 +0000 (GMT)
Received: from R01UKEXCASM223.r01.fujitsu.local (R01UKEXCASM223 [10.182.185.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by n03ukasimr03.n03.fujitsu.local (Postfix) with ESMTPS id 8F6551AC;
	Thu,  2 Feb 2023 12:34:01 +0000 (GMT)
Received: from localhost.localdomain (10.167.225.141) by
 R01UKEXCASM223.r01.fujitsu.local (10.182.185.121) with Microsoft SMTP Server
 (TLS) id 15.0.1497.42; Thu, 2 Feb 2023 12:33:58 +0000
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-xfs@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <david@fromorbit.com>, <dan.j.williams@intel.com>,
	<akpm@linux-foundation.org>, <ruansy.fnst@fujitsu.com>
Subject: [PATCH] fsdax: dax_unshare_iter() should return a valid length
Date: Thu, 2 Feb 2023 12:33:47 +0000
Message-ID: <1675341227-14-1-git-send-email-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.225.141]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM223.r01.fujitsu.local (10.182.185.121)
X-Virus-Scanned: ClamAV using ClamSMTP

The copy_mc_to_kernel() will return 0 if it executed successfully.
Then the return value should be set to the length it copied.

Fixes: d984648e428b ("fsdax,xfs: port unshare to fsdax")
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 fs/dax.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/dax.c b/fs/dax.c
index c48a3a93ab29..a5b4deb5def3 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1274,6 +1274,7 @@ static s64 dax_unshare_iter(struct iomap_iter *iter)
 	ret = copy_mc_to_kernel(daddr, saddr, length);
 	if (ret)
 		ret = -EIO;
+	ret = length;
 
 out_unlock:
 	dax_read_unlock(id);
-- 
2.39.1

