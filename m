Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B8CFE21D147CD
 for <linux-nvdimm@lists.01.org>; Wed, 19 Jul 2017 11:37:47 -0700 (PDT)
Subject: [ndctl PATCH 4/6] ndctl, list: emit device-dax 'chardev' by default
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Jul 2017 11:33:17 -0700
Message-ID: <150048919740.12895.4759356543014868451.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150048917662.12895.15953645444185664230.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150048917662.12895.15953645444185664230.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Commit 10663a60d723 "ndctl, list: add '--device-dax' option" tried to
cleanup the default namespace output by putting the device-dax details
behind an extra option. This was done in anticipation of device-dax
sub-division support, but the kernel has since added support for
multiple-pmem namespaces per region and limiting device-dax instances to
one per parent namespace. With the limitation in place we can directly
associate a device-dax instance with a namespace and omit the dax-region
details in ndctl.

Reported-by: Linda Knippers <linda.knippers@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 util/json.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/util/json.c b/util/json.c
index 80512bdabeae..25188a61064f 100644
--- a/util/json.c
+++ b/util/json.c
@@ -622,18 +622,28 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 	} else if (dax) {
 		struct daxctl_region *dax_region;
 
+		dax_region = ndctl_dax_get_daxctl_region(dax);
 		ndctl_dax_get_uuid(dax, uuid);
 		uuid_unparse(uuid, buf);
 		jobj = json_object_new_string(buf);
 		if (!jobj)
 			goto err;
 		json_object_object_add(jndns, "uuid", jobj);
-		if (flags & UTIL_JSON_DAX) {
-			dax_region = ndctl_dax_get_daxctl_region(dax);
+		if ((flags & UTIL_JSON_DAX) && dax_region) {
 			jobj = util_daxctl_region_to_json(dax_region, NULL,
 					flags);
 			if (jobj)
 				json_object_object_add(jndns, "daxregion", jobj);
+		} else if (dax_region) {
+			struct daxctl_dev *dev;
+			const char *name;
+
+			dev = daxctl_dev_get_first(dax_region);
+			name = daxctl_dev_get_devname(dev);
+			jobj = json_object_new_string(name);
+			if (!jobj)
+				goto err;
+			json_object_object_add(jndns, "chardev", jobj);
 		}
 	} else if (ndctl_namespace_get_type(ndns) != ND_DEVICE_NAMESPACE_IO) {
 		const char *name;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
