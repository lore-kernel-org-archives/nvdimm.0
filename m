Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFEF6D00
	for <nvdimm@lists.linux.dev>; Tue, 15 Jun 2021 12:38:36 +0000 (UTC)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G478C2yYQzZhcs
	for <nvdimm@lists.linux.dev>; Tue, 15 Jun 2021 20:35:39 +0800 (CST)
Received: from dggema765-chm.china.huawei.com (10.1.198.207) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 20:38:34 +0800
Received: from [127.0.0.1] (10.174.177.249) by dggema765-chm.china.huawei.com
 (10.1.198.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 15
 Jun 2021 20:38:33 +0800
Subject: [ndctl PATCH 1/2] libndctl: check return value of
 ndctl_pfn_get_namespace
To: <vishal.l.verma@intel.com>
CC: <nvdimm@lists.linux.dev>, <linfeilong@huawei.com>, lixiaokeng
	<lixiaokeng@huawei.com>, <liuzhiqiang26@huawei.com>
References: <d9881921-aef7-5410-1536-71df81227f4b@huawei.com>
From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <b899e8ba-560c-88e6-3b49-2bdf14eab150@huawei.com>
Date: Tue, 15 Jun 2021 20:38:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <d9881921-aef7-5410-1536-71df81227f4b@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.249]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggema765-chm.china.huawei.com (10.1.198.207)
X-CFilter-Loop: Reflected


ndctl_pfn_get_namespace() may return NULL, so callers
should check return value of it. Otherwise, it may
cause access NULL pointer problem.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
---
 ndctl/namespace.c | 18 ++++++++++++++----
 test/libndctl.c   |  4 ++--
 util/json.c       |  2 ++
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 0c8df9f..21089d7 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -1417,11 +1417,16 @@ static int nstype_clear_badblocks(struct ndctl_namespace *ndns,

 static int dax_clear_badblocks(struct ndctl_dax *dax)
 {
-	struct ndctl_namespace *ndns = ndctl_dax_get_namespace(dax);
-	const char *devname = ndctl_dax_get_devname(dax);
+	struct ndctl_namespace *ndns;
+	const char *devname;
 	unsigned long long begin, size;
 	int rc;

+	ndns = ndctl_dax_get_namespace(dax);
+	if (!ndns)
+		return -ENXIO;
+
+	devname = ndctl_dax_get_devname(dax);
 	begin = ndctl_dax_get_resource(dax);
 	if (begin == ULLONG_MAX)
 		return -ENXIO;
@@ -1441,11 +1446,16 @@ static int dax_clear_badblocks(struct ndctl_dax *dax)

 static int pfn_clear_badblocks(struct ndctl_pfn *pfn)
 {
-	struct ndctl_namespace *ndns = ndctl_pfn_get_namespace(pfn);
-	const char *devname = ndctl_pfn_get_devname(pfn);
+	struct ndctl_namespace *ndns;
+	const char *devname;
 	unsigned long long begin, size;
 	int rc;

+	ndns = ndctl_pfn_get_namespace(pfn);
+	if (!ndns)
+		return -ENXIO;
+
+	devname = ndctl_pfn_get_devname(pfn);
 	begin = ndctl_pfn_get_resource(pfn);
 	if (begin == ULLONG_MAX)
 		return -ENXIO;
diff --git a/test/libndctl.c b/test/libndctl.c
index 24d72b3..05e5ff2 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -1275,7 +1275,7 @@ static int check_pfn_autodetect(struct ndctl_bus *bus,
 		if (!ndctl_pfn_is_enabled(pfn))
 			continue;
 		pfn_ndns = ndctl_pfn_get_namespace(pfn);
-		if (strcmp(ndctl_namespace_get_devname(pfn_ndns), devname) != 0)
+		if (!pfn_ndns || strcmp(ndctl_namespace_get_devname(pfn_ndns), devname) != 0)
 			continue;
 		fprintf(stderr, "%s: pfn_ndns: %p ndns: %p\n", __func__,
 				pfn_ndns, ndns);
@@ -1372,7 +1372,7 @@ static int check_dax_autodetect(struct ndctl_bus *bus,
 		if (!ndctl_dax_is_enabled(dax))
 			continue;
 		dax_ndns = ndctl_dax_get_namespace(dax);
-		if (strcmp(ndctl_namespace_get_devname(dax_ndns), devname) != 0)
+		if (!dax_ndns || strcmp(ndctl_namespace_get_devname(dax_ndns), devname) != 0)
 			continue;
 		fprintf(stderr, "%s: dax_ndns: %p ndns: %p\n", __func__,
 				dax_ndns, ndns);
diff --git a/util/json.c b/util/json.c
index ca0167b..249f021 100644
--- a/util/json.c
+++ b/util/json.c
@@ -1002,6 +1002,8 @@ static struct json_object *util_pfn_badblocks_to_json(struct ndctl_pfn *pfn,
 	pfn_begin = ndctl_pfn_get_resource(pfn);
 	if (pfn_begin == ULLONG_MAX) {
 		struct ndctl_namespace *ndns = ndctl_pfn_get_namespace(pfn);
+		if (!ndns)
+			return NULL;

 		return util_namespace_badblocks_to_json(ndns, bb_count, flags);
 	}
-- 
2.23.0




.



