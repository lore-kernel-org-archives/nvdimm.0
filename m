Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com
 [IPv6:2607:f8b0:4864:20::443])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 35FB9211BFCC4
 for <linux-nvdimm@lists.01.org>; Wed, 30 Jan 2019 02:59:50 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id q1so11247781pfi.5
 for <linux-nvdimm@lists.01.org>; Wed, 30 Jan 2019 02:59:50 -0800 (PST)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH v5 6/7] ndctl/namespace: Make the create-region JSON output
 non-verbose
Date: Wed, 30 Jan 2019 21:59:26 +1100
Message-Id: <20190130105927.31901-6-oohall@gmail.com>
In-Reply-To: <20190130105927.31901-1-oohall@gmail.com>
References: <20190130105927.31901-1-oohall@gmail.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The ndctl unit tests parse the output of the create-region commands using a
pile of regexs which makes adding new fields to create-namespace output
blob a somewhat fraught activity. By moving the existing "verbose" fields
into the normal output we keep the unit tests happy and allow ourselves to
add more fields in the future.

This patch also makes the 'sector_size' field non-verbose since the BTT
unit tests require it.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
Ccurrently `ndctl list` has the -v flag to make the output more verbose,
however every other ndctl command uses -v as a switch to enable debug
output. We probably don't want to change the CLI much, but considering
debug output requires running configure with --enable-debug it might be
a good idea to change it to -d or something and free up the switch for
actual verbosity.
---
---
 ndctl/namespace.c | 2 +-
 util/json.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 25e0a87676e4..03d805a69ce4 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -424,7 +424,7 @@ static int setup_namespace(struct ndctl_region *region,
 		error("%s: failed to enable\n",
 				ndctl_namespace_get_devname(ndns));
 	} else {
-		unsigned long flags = UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS | UTIL_JSON_VERBOSE;
+		unsigned long flags = UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS;
 		struct json_object *jndns;
 
 		if (isatty(1))
diff --git a/util/json.c b/util/json.c
index 77c96fb53c27..eee459aa453b 100644
--- a/util/json.c
+++ b/util/json.c
@@ -893,7 +893,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 	 * happens because they use pre-v1.2 labels or because they
 	 * don't have a label space (devtype=nd_namespace_io).
 	 */
-	if (sector_size < UINT_MAX && flags & UTIL_JSON_VERBOSE) {
+	if (sector_size < UINT_MAX) {
 		jobj = json_object_new_int(sector_size);
 		if (!jobj)
 			goto err;
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
