Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 30D0E1A1EC2
 for <linux-nvdimm@lists.01.org>; Tue, 26 Apr 2016 16:58:19 -0700 (PDT)
Subject: [ndctl PATCH 2/2] ndctl, list: add 'id' to the dimm listing
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Apr 2016 16:57:30 -0700
Message-ID: <146171505042.32030.8733064490141646370.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146171495520.32030.11537526996792266896.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146171495520.32030.11537526996792266896.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Emit the ACPI 6.1 defined DIMM identfier if available.

# ndctl list -D -d nmem0
{
  "dev":"nmem0",
  "id":"cdab-ffffffff"
}

Cc: Toshi Kani <toshi.kani@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 util/json.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/util/json.c b/util/json.c
index 4e2d902a183e..1d914da318fa 100644
--- a/util/json.c
+++ b/util/json.c
@@ -53,6 +53,7 @@ struct json_object *util_bus_to_json(struct ndctl_bus *bus)
 struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm)
 {
 	struct json_object *jdimm = json_object_new_object();
+	const char *id = ndctl_dimm_get_unique_id(dimm);
 	struct json_object *jobj;
 
 	if (!jdimm)
@@ -63,6 +64,13 @@ struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm)
 		goto err;
 	json_object_object_add(jdimm, "dev", jobj);
 
+	if (id) {
+		jobj = json_object_new_string(id);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jdimm, "id", jobj);
+	}
+
 	if (!ndctl_dimm_is_enabled(dimm)) {
 		jobj = json_object_new_string("disabled");
 		if (!jobj)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
