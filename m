Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546B8A45
	for <nvdimm@lists.linux.dev>; Fri, 14 Apr 2023 10:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de; s=s29768273;
	t=1681467159; i=markus.elfring@web.de;
	bh=lN199BU3w8BH95ejvYLphaLC4iAwuMPDfeqw1lQTsoA=;
	h=X-UI-Sender-Class:Date:Subject:From:To:References:Cc:In-Reply-To;
	b=nuXz4iifez1QNdL6oPTSEN728ohy/LFbPMRqitEWszGmxivbRTdFZUB7tc1MldLEc
	 nbZqMWUjW2Nsp503Zb3vbGkn29mUhugpsXt7zI8xklWnGW8Cm7qy9SOF9W5iMlJVdL
	 QLWZOzBbfCg25PEhsH0MSxftqLojlwwMjbGVopxd3jAkn1wDZfkCcmIgrNsVL+AERP
	 V26pFujfrQwFYNupwa8/HDKRWTgQxU2LULgJEC+wZKJbBL9jIhJb3YwWvVzTED5KtY
	 uZiIbDpUQOufAC3PShNXSDaXpy9kPWRkFzJab5qrmEbcXcH64pjCVicYUQGheo2HSO
	 3uBhV+TBQgOLg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.85.83]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MFJjP-1pXa2R3juD-00FWpN; Fri, 14
 Apr 2023 12:12:38 +0200
Message-ID: <d2403b7a-c6cd-4ee9-2a35-86ea57554eec@web.de>
Date: Fri, 14 Apr 2023 12:12:37 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: [PATCH] nvdimm: Replace the usage of a variable by a direct function
 call in nd_pfn_validate()
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
To: kernel-janitors@vger.kernel.org, nvdimm@lists.linux.dev,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Vishal Verma <vishal.l.verma@intel.com>
References: <40c60719-4bfe-b1a4-ead7-724b84637f55@web.de>
 <1a11455f-ab57-dce0-1677-6beb8492a257@web.de>
Cc: cocci@inria.fr, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1a11455f-ab57-dce0-1677-6beb8492a257@web.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:vhhUPiJeCCaH4MxrzXr0ksbYGwZgjHgg6HIUEM3qklSUa8+u/vG
 PC3S6S7GsJkfEi6QMGKNPiXwMXcW631Qs/3kevyJah/dNcUaFzHu18JPqSQVOon88Da6X3k
 A0V2sPqb1C4dzoMn56mHb2ioOx2ellmna4VQoaOLZdveDW1pG4BWFjVv6ExbVuhVuzaeSqg
 oKdor1fs4UvjyWhX/3Wlg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:NFR9Ei6rdzo=;W0kExL0/7XLx6N3n/OwQ0N2ZzlE
 61+rPcpb9n+aL6wOeCK8L/NxirUXeaUpGtTcqgx60it4sF61ZuPZjOHAz4pMnlRfDR2I4EP8D
 9ZXEnPYHInW4kZ/Vnycvvjnunv+kDlG7NLCWbCcCt3P3KVHKesRCmEu7xx4AnKlcyLZ9+98dQ
 osPHxrAuoPBVg/sQd811OU0+JfTe7eHe9IWH2zNkBlG0DLExu4Osr4HkLyIHWW5x9o+qPLZ0G
 R5A8P9B2LuzT0QjUapNq+RvXO4HrIe5oQ3GNjVH+W13RGA9VVJTyk1r4LSfQD9zwXn4i/+QDU
 lE16IJV8wFKXtFZbMV/MipFxM/xhG1/ocghTE38D1NHoVFfcOCIbN52dac9zRvJTjY1/cQH8T
 NRxYAHXdy1LZUcp2Zuf2s4V3KZRLOpQ34srdr9htdXQ3ZCl74T+Eyp3T2dYXEg/bb/YcnTuuD
 uS0kcSpLYSYQYWKICFkd+2VrOyL04wtjNsu/u4mKx6Q4gqsbzu0r2DXfNLdYWrALINzC9Zor0
 KahycRHwKVKO03rJ2966C/g5ck8oYDU2cmdNwrX8qUI3fq/tMjIJucHHpa5R2XxsfCWIyBOrf
 uWYCxJI/oti37QgmrFjeBt3YL7q8jzi8mtM2orQKpKXne7EYED0erXIUr8jecaUdQ6moDYFXZ
 hjGmpHfo484v2m97ZKjBqOctOoVL0+lArpY5XjYHmCp6XjK8X9OjoOKD9QMTIsNO9OPEAGMxz
 9W4dP894YQekfzO+2JuYJNyAZDqtbdwGxIGj/lfG087BVvSE2HvA21bdwgegt/j+di3uRpzj5
 lwHzfRIKqsEM0fvaHTv3UyV3vn3HfhkSh8v8bTQcmQQHmTacA78VBqAiU0+plaATWvdLsIjVd
 pNHCDUflS0AFjdVwpd+IyOGvgL2xObDPyrGZ5vudy85vmZ0ODWUVvLjjE

Date: Fri, 14 Apr 2023 12:01:15 +0200

The address of a data structure member was determined before
a corresponding null pointer check in the implementation of
the function =E2=80=9Cnd_pfn_validate=E2=80=9D.

Thus avoid the risk for undefined behaviour by replacing the usage of
the local variable =E2=80=9Cparent_uuid=E2=80=9D by a direct function call=
 within
a later condition check.

This issue was detected by using the Coccinelle software.

Fixes: d1c6e08e7503649e4a4f3f9e700e2c05300b6379 ("libnvdimm/labels: Add uu=
id helpers")
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/nvdimm/pfn_devs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index af7d9301520c..f14cbfa500ed 100644
=2D-- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -456,7 +456,6 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char =
*sig)
 	unsigned long align, start_pad;
 	struct nd_pfn_sb *pfn_sb =3D nd_pfn->pfn_sb;
 	struct nd_namespace_common *ndns =3D nd_pfn->ndns;
-	const uuid_t *parent_uuid =3D nd_dev_to_uuid(&ndns->dev);

 	if (!pfn_sb || !ndns)
 		return -ENODEV;
@@ -476,7 +475,7 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char =
*sig)
 		return -ENODEV;
 	pfn_sb->checksum =3D cpu_to_le64(checksum);

-	if (memcmp(pfn_sb->parent_uuid, parent_uuid, 16) !=3D 0)
+	if (memcmp(pfn_sb->parent_uuid, nd_dev_to_uuid(&ndns->dev), 16) !=3D 0)
 		return -ENODEV;

 	if (__le16_to_cpu(pfn_sb->version_minor) < 1) {
=2D-
2.40.0

