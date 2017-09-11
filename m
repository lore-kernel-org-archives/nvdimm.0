Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm03.jp.fujitsu.com (mgwkm03.jp.fujitsu.com [202.219.69.170])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B4DD120958BCF
 for <linux-nvdimm@lists.01.org>; Sun, 10 Sep 2017 19:36:28 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 581CCAC00B2
 for <linux-nvdimm@lists.01.org>; Mon, 11 Sep 2017 11:39:17 +0900 (JST)
Date: Mon, 11 Sep 2017 11:39:03 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [PATCH ndctl] ndctl: sort by dimm's number when bad dimms are shown.
In-Reply-To: <20170911112149.17E3.E1E9C6FF@jp.fujitsu.com>
References: <150490956040.8621.9918102309170733621.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170911112149.17E3.E1E9C6FF@jp.fujitsu.com>
Message-Id: <20170911113900.17E6.E1E9C6FF@jp.fujitsu.com>
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

> > +
> > +	if (!found)
> > +		goto err_found;
> > +
> > +	for (i = 0; i < found; i++) {
> > +		const char *devname = ndctl_dimm_get_devname(dimms[i]);
> > +
> > +		jobj = json_object_new_string(devname);
> > +		if (!jobj)
> > +			break;
> > +		json_object_array_add(jdimms, jobj);
> > +	}
> 
> I have one comment.
> 
> If output is sorted by device number here,
> it may be friendly for users. 
> (Especially, # of interleave way becomes huge in future...)
> 
> Other things are looks good for me.

I made a patch to make sorting.
I hope it will help....

-------
To make user friendly, it is desirable that ndctl sorts by dimm's number,
when output dimms which have badblocks.
    
Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

---
 util/json.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/util/json.c b/util/json.c
index 9b7773e..dac8692 100644
--- a/util/json.c
+++ b/util/json.c
@@ -366,6 +366,21 @@ struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
 	return NULL;
 }
 
+static int compare_dimm_number(const void *p1, const void *p2)
+{
+	struct ndctl_dimm *dimm1 = *(struct ndctl_dimm **)p1;
+	struct ndctl_dimm *dimm2 = *(struct ndctl_dimm **)p2;
+	const char *dimm1_name = ndctl_dimm_get_devname(dimm1);
+	const char *dimm2_name = ndctl_dimm_get_devname(dimm2);
+	int num1, num2;
+
+	sscanf(dimm1_name, "nmem%d", &num1);
+	sscanf(dimm2_name, "nmem%d", &num2);
+
+	return num1 - num2;
+
+}
+
 static struct json_object *badblocks_to_jdimms(struct ndctl_region *region,
 		unsigned long long addr, unsigned long len)
 {
@@ -399,6 +414,8 @@ static struct json_object *badblocks_to_jdimms(struct ndctl_region *region,
 	if (!found)
 		goto err_found;
 
+	qsort(dimms, found, sizeof(dimm), compare_dimm_number);
+
 	for (i = 0; i < found; i++) {
 		const char *devname = ndctl_dimm_get_devname(dimms[i]);
 




_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
