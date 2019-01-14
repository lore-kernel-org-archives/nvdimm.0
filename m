Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5A23621197374
 for <linux-nvdimm@lists.01.org>; Mon, 14 Jan 2019 10:49:13 -0800 (PST)
Date: Mon, 14 Jan 2019 11:49:12 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v3 4/4] ndctl: clean up usage of ndctl_cmd_submit
Message-ID: <20190114184912.GA17520@vverma7-desk1.lm.intel.com>
References: <20190114181115.11983-1-vishal.l.verma@intel.com>
 <20190114181115.11983-5-vishal.l.verma@intel.com>
 <CAPcyv4j7R6_V4fkoOYavswCSZGXVLnAD=3E3gZy+RSedsuTgVA@mail.gmail.com>
 <a5dbd65d944a2cf45e1ebbfbb4b2e898f3a86778.camel@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a5dbd65d944a2cf45e1ebbfbb4b2e898f3a86778.camel@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 01/14, Verma, Vishal L wrote:
> 
> On Mon, 2019-01-14 at 10:17 -0800, Dan Williams wrote:
> > On Mon, Jan 14, 2019 at 10:11 AM Vishal Verma <
> > vishal.l.verma@intel.com> wrote:
> > > 
> > > It is possible for ndctl_cmd_submit to return a positive number,
> > > indicating a buffer underrun. It is only truly an error if it
> > > returns a
> > > negative number. Several places in the library, the ndctl utility,
> > > and
> > > in test/ were simply checking for an error with "if (rc)". Fix
> > > these to
> > > only error out for negative returns.
> > > 
> > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > > ---
> > >  ndctl/lib/dimm.c              |  6 +++---
> > >  ndctl/lib/inject.c            |  8 ++++----
> > >  ndctl/lib/nfit.c              |  2 +-
> > >  ndctl/util/json-firmware.c    |  2 +-
> > >  test/ack-shutdown-count-set.c |  8 ++------
> > >  test/daxdev-errors.c          |  8 ++++----
> > >  test/libndctl.c               | 32 ++++++++++++++++---------------
> > > -
> > >  test/smart-notify.c           |  8 ++++----
> > >  8 files changed, 35 insertions(+), 39 deletions(-)
> > > 
> > > diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
> > > index 79e2ca0..12dc74a 100644
> > > --- a/ndctl/lib/dimm.c
> > > +++ b/ndctl/lib/dimm.c
> > > @@ -332,7 +332,7 @@ static int nvdimm_set_config_data(struct
> > > nvdimm_data *ndd, size_t offset,
> > >                 goto out;
> > > 
> > >         rc = ndctl_cmd_submit(cmd_write);
> > > -       if (rc || ndctl_cmd_get_firmware_status(cmd_write))
> > > +       if ((rc < 0) || ndctl_cmd_get_firmware_status(cmd_write))
> > 
> > With ndctl_cmd_submit_xlat() the ndctl_cmd_get_firmware_status() can
> > be dropped, right?
> > 
> >     rc = ndctl_cmd_submit_xlat(cmd_write);
> >     if (rc < 0)
> >         rc = -ENXIO;
> > 
> > 
> > ...or are you saving that conversion for a follow on patch?
> 
> The config get/write commands are not dimm_ops right? I thought we
> could only use _xlat for dimm_ops?

I see how it can be replaced now. Here is a revised patch 4 that
includes thses conversions:

8<----


>From 5c19c269dd0037c3f68725e0f721784056172433 Mon Sep 17 00:00:00 2001
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Fri, 11 Jan 2019 18:20:31 -0700
Subject: [ndctl PATCH] ndctl: clean up usage of ndctl_cmd_submit

It is possible for ndctl_cmd_submit to return a positive number,
indicating a buffer underrun. It is only truly an error if it returns a
negative number. Several places in the library, the ndctl utility, and
in test/ were simply checking for an error with "if (rc)". Fix these to
only error out for negative returns.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/dimm.c              | 18 +++++++-----------
 ndctl/lib/inject.c            |  8 ++++----
 ndctl/lib/nfit.c              |  2 +-
 ndctl/util/json-firmware.c    |  2 +-
 test/ack-shutdown-count-set.c |  8 ++------
 test/daxdev-errors.c          |  8 ++++----
 test/libndctl.c               | 32 ++++++++++++++++----------------
 test/smart-notify.c           |  8 ++++----
 8 files changed, 39 insertions(+), 47 deletions(-)

diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index 79e2ca0..f5a955e 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -331,8 +331,8 @@ static int nvdimm_set_config_data(struct nvdimm_data *ndd, size_t offset,
 	if (rc < 0)
 		goto out;
 
-	rc = ndctl_cmd_submit(cmd_write);
-	if (rc || ndctl_cmd_get_firmware_status(cmd_write))
+	rc = ndctl_cmd_submit_xlat(cmd_write);
+	if (rc < 0)
 		rc = -ENXIO;
  out:
 	ndctl_cmd_unref(cmd_write);
@@ -487,15 +487,15 @@ NDCTL_EXPORT struct ndctl_cmd *ndctl_dimm_read_labels(struct ndctl_dimm *dimm)
         cmd_size = ndctl_dimm_cmd_new_cfg_size(dimm);
         if (!cmd_size)
                 return NULL;
-        rc = ndctl_cmd_submit(cmd_size);
-        if (rc || ndctl_cmd_get_firmware_status(cmd_size))
+        rc = ndctl_cmd_submit_xlat(cmd_size);
+        if (rc < 0)
                 goto out_size;
 
         cmd_read = ndctl_dimm_cmd_new_cfg_read(cmd_size);
         if (!cmd_read)
                 goto out_size;
-        rc = ndctl_cmd_submit(cmd_read);
-        if (rc || ndctl_cmd_get_firmware_status(cmd_read))
+        rc = ndctl_cmd_submit_xlat(cmd_read);
+        if (rc < 0)
                 goto out_read;
 	ndctl_cmd_unref(cmd_size);
 
@@ -536,13 +536,9 @@ NDCTL_EXPORT int ndctl_dimm_zero_labels(struct ndctl_dimm *dimm)
 		rc = -ENXIO;
 		goto out_write;
 	}
-	rc = ndctl_cmd_submit(cmd_write);
+	rc = ndctl_cmd_submit_xlat(cmd_write);
 	if (rc < 0)
 		goto out_write;
-	if (ndctl_cmd_get_firmware_status(cmd_write)) {
-		rc = -ENXIO;
-		goto out_write;
-	}
 
 	/*
 	 * If the dimm is already disabled the kernel is not holding a cached
diff --git a/ndctl/lib/inject.c b/ndctl/lib/inject.c
index 2b0702e..c35d0f3 100644
--- a/ndctl/lib/inject.c
+++ b/ndctl/lib/inject.c
@@ -156,7 +156,7 @@ static int ndctl_namespace_inject_one_error(struct ndctl_namespace *ndns,
 			(1 << ND_ARS_ERR_INJ_OPT_NOTIFY);
 
 	rc = ndctl_cmd_submit(cmd);
-	if (rc) {
+	if (rc < 0) {
 		dbg(ctx, "Error submitting command: %d\n", rc);
 		goto out;
 	}
@@ -234,7 +234,7 @@ static int ndctl_namespace_uninject_one_error(struct ndctl_namespace *ndns,
 	err_inj_clr->err_inj_clr_spa_range_length = length;
 
 	rc = ndctl_cmd_submit(cmd);
-	if (rc) {
+	if (rc < 0) {
 		dbg(ctx, "Error submitting command: %d\n", rc);
 		goto out;
 	}
@@ -443,7 +443,7 @@ NDCTL_EXPORT int ndctl_namespace_injection_status(struct ndctl_namespace *ndns)
 
 		cmd = ndctl_bus_cmd_new_ars_cap(bus, ns_offset, ns_size);
 		rc = ndctl_cmd_submit(cmd);
-		if (rc) {
+		if (rc < 0) {
 			dbg(ctx, "Error submitting ars_cap: %d\n", rc);
 			goto out;
 		}
@@ -464,7 +464,7 @@ NDCTL_EXPORT int ndctl_namespace_injection_status(struct ndctl_namespace *ndns)
 			(struct nd_cmd_ars_err_inj_stat *)&pkg->nd_payload[0];
 
 		rc = ndctl_cmd_submit(cmd);
-		if (rc) {
+		if (rc < 0) {
 			dbg(ctx, "Error submitting command: %d\n", rc);
 			goto out;
 		}
diff --git a/ndctl/lib/nfit.c b/ndctl/lib/nfit.c
index 2ae3f07..b10edb1 100644
--- a/ndctl/lib/nfit.c
+++ b/ndctl/lib/nfit.c
@@ -133,7 +133,7 @@ int ndctl_bus_nfit_translate_spa(struct ndctl_bus *bus,
 	translate_spa->spa = address;
 
 	rc = ndctl_cmd_submit(cmd);
-	if (rc) {
+	if (rc < 0) {
 		ndctl_cmd_unref(cmd);
 		return rc;
 	}
diff --git a/ndctl/util/json-firmware.c b/ndctl/util/json-firmware.c
index 118424f..f7150d8 100644
--- a/ndctl/util/json-firmware.c
+++ b/ndctl/util/json-firmware.c
@@ -25,7 +25,7 @@ struct json_object *util_dimm_firmware_to_json(struct ndctl_dimm *dimm,
 		goto err;
 
 	rc = ndctl_cmd_submit(cmd);
-	if (rc || ndctl_cmd_fw_xlat_firmware_status(cmd) != FW_SUCCESS) {
+	if ((rc < 0) || ndctl_cmd_fw_xlat_firmware_status(cmd) != FW_SUCCESS) {
 		jobj = util_json_object_hex(-1, flags);
 		if (jobj)
 			json_object_object_add(jfirmware, "current_version",
diff --git a/test/ack-shutdown-count-set.c b/test/ack-shutdown-count-set.c
index 9baa2f1..742e976 100644
--- a/test/ack-shutdown-count-set.c
+++ b/test/ack-shutdown-count-set.c
@@ -27,12 +27,8 @@ static int test_dimm(struct ndctl_dimm *dimm)
 	if (!cmd)
 		return -ENOMEM;
 
-	rc = ndctl_cmd_submit(cmd);
-	if (rc < 0)
-		goto out;
-
-	rc = ndctl_cmd_get_firmware_status(cmd);
-	if (rc != 0) {
+	rc = ndctl_cmd_submit_xlat(cmd);
+	if (rc < 0) {
 		fprintf(stderr, "dimm %s LSS enable set failed\n",
 				ndctl_dimm_get_devname(dimm));
 		goto out;
diff --git a/test/daxdev-errors.c b/test/daxdev-errors.c
index 94fbebe..29de16b 100644
--- a/test/daxdev-errors.c
+++ b/test/daxdev-errors.c
@@ -75,7 +75,7 @@ static int check_ars_cap(struct ndctl_bus *bus, uint64_t start,
 	}
 
 	rc = ndctl_cmd_submit(cmd);
-	if (rc) {
+	if (rc < 0) {
 		fprintf(stderr, "%s: bus: %s failed to submit cmd: %d\n",
 				__func__, ndctl_bus_get_provider(bus), rc);
 		ndctl_cmd_unref(cmd);
@@ -115,7 +115,7 @@ static int check_ars_start(struct ndctl_bus *bus, struct check_cmd *check)
 	}
 
 	rc = ndctl_cmd_submit(cmd);
-	if (rc) {
+	if (rc < 0) {
 		fprintf(stderr, "%s: bus: %s failed to submit cmd: %d\n",
 				__func__, ndctl_bus_get_provider(bus), rc);
 		ndctl_cmd_unref(cmd);
@@ -149,7 +149,7 @@ static int check_ars_status(struct ndctl_bus *bus, struct check_cmd *check)
 	}
 
 	rc = ndctl_cmd_submit(cmd);
-	if (rc) {
+	if (rc < 0) {
 		fprintf(stderr, "%s: bus: %s failed to submit cmd: %d\n",
 				__func__, ndctl_bus_get_provider(bus), rc);
 		ndctl_cmd_unref(cmd);
@@ -210,7 +210,7 @@ static int check_clear_error(struct ndctl_bus *bus, struct check_cmd *check)
 	}
 
 	rc = ndctl_cmd_submit(clear_err);
-	if (rc) {
+	if (rc < 0) {
 		fprintf(stderr, "%s: bus: %s failed to submit cmd: %d\n",
 				__func__, ndctl_bus_get_provider(bus), rc);
 		ndctl_cmd_unref(clear_err);
diff --git a/test/libndctl.c b/test/libndctl.c
index 50365f0..02bb9cc 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -2057,7 +2057,7 @@ static int check_get_config_size(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	}
 
 	rc = ndctl_cmd_submit(cmd);
-	if (rc) {
+	if (rc < 0) {
 		fprintf(stderr, "%s: dimm: %#x failed to submit cmd: %d\n",
 			__func__, ndctl_dimm_get_handle(dimm), rc);
 		ndctl_cmd_unref(cmd);
@@ -2091,7 +2091,7 @@ static int check_get_config_data(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	}
 
 	rc = ndctl_cmd_submit(cmd);
-	if (rc) {
+	if (rc < 0) {
 		fprintf(stderr, "%s: dimm: %#x failed to submit cmd: %zd\n",
 			__func__, ndctl_dimm_get_handle(dimm), rc);
 		ndctl_cmd_unref(cmd);
@@ -2116,7 +2116,7 @@ static int check_set_config_data(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	struct ndctl_cmd *cmd_read = check_cmds[ND_CMD_GET_CONFIG_DATA].cmd;
 	struct ndctl_cmd *cmd = ndctl_dimm_cmd_new_cfg_write(cmd_read);
 	char buf[20], result[sizeof(buf)];
-	size_t rc;
+	int rc;
 
 	if (!cmd) {
 		fprintf(stderr, "%s: dimm: %#x failed to create cmd\n",
@@ -2127,23 +2127,23 @@ static int check_set_config_data(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	memset(buf, 0, sizeof(buf));
 	ndctl_cmd_cfg_write_set_data(cmd, buf, sizeof(buf), 0);
 	rc = ndctl_cmd_submit(cmd);
-	if (rc) {
-		fprintf(stderr, "%s: dimm: %#x failed to submit cmd: %zd\n",
+	if (rc < 0) {
+		fprintf(stderr, "%s: dimm: %#x failed to submit cmd: %d\n",
 			__func__, ndctl_dimm_get_handle(dimm), rc);
 		ndctl_cmd_unref(cmd);
 		return rc;
 	}
 
 	rc = ndctl_cmd_submit(cmd_read);
-	if (rc) {
-		fprintf(stderr, "%s: dimm: %#x failed to submit read1: %zd\n",
+	if (rc < 0) {
+		fprintf(stderr, "%s: dimm: %#x failed to submit read1: %d\n",
 				__func__, ndctl_dimm_get_handle(dimm), rc);
 		ndctl_cmd_unref(cmd);
 		return rc;
 	}
 	ndctl_cmd_cfg_read_get_data(cmd_read, result, sizeof(result), 0);
 	if (memcmp(result, buf, sizeof(result)) != 0) {
-		fprintf(stderr, "%s: dimm: %#x read1 data miscompare: %zd\n",
+		fprintf(stderr, "%s: dimm: %#x read1 data miscompare: %d\n",
 				__func__, ndctl_dimm_get_handle(dimm), rc);
 		ndctl_cmd_unref(cmd);
 		return -ENXIO;
@@ -2152,23 +2152,23 @@ static int check_set_config_data(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	sprintf(buf, "dimm-%#x", ndctl_dimm_get_handle(dimm));
 	ndctl_cmd_cfg_write_set_data(cmd, buf, sizeof(buf), 0);
 	rc = ndctl_cmd_submit(cmd);
-	if (rc) {
-		fprintf(stderr, "%s: dimm: %#x failed to submit cmd: %zd\n",
+	if (rc < 0) {
+		fprintf(stderr, "%s: dimm: %#x failed to submit cmd: %d\n",
 			__func__, ndctl_dimm_get_handle(dimm), rc);
 		ndctl_cmd_unref(cmd);
 		return rc;
 	}
 
 	rc = ndctl_cmd_submit(cmd_read);
-	if (rc) {
-		fprintf(stderr, "%s: dimm: %#x failed to submit read2: %zd\n",
+	if (rc < 0) {
+		fprintf(stderr, "%s: dimm: %#x failed to submit read2: %d\n",
 				__func__, ndctl_dimm_get_handle(dimm), rc);
 		ndctl_cmd_unref(cmd);
 		return rc;
 	}
 	ndctl_cmd_cfg_read_get_data(cmd_read, result, sizeof(result), 0);
 	if (memcmp(result, buf, sizeof(result)) != 0) {
-		fprintf(stderr, "%s: dimm: %#x read2 data miscompare: %zd\n",
+		fprintf(stderr, "%s: dimm: %#x read2 data miscompare: %d\n",
 				__func__, ndctl_dimm_get_handle(dimm), rc);
 		ndctl_cmd_unref(cmd);
 		return rc;
@@ -2225,7 +2225,7 @@ static int check_smart(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	}
 
 	rc = ndctl_cmd_submit(cmd);
-	if (rc) {
+	if (rc < 0) {
 		fprintf(stderr, "%s: dimm: %#x failed to submit cmd: %d\n",
 			__func__, ndctl_dimm_get_handle(dimm), rc);
 		ndctl_cmd_unref(cmd);
@@ -2326,7 +2326,7 @@ static int check_smart_threshold(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	}
 
 	rc = ndctl_cmd_submit(cmd);
-	if (rc) {
+	if (rc < 0) {
 		fprintf(stderr, "%s: dimm: %#x failed to submit cmd: %d\n",
 			__func__, ndctl_dimm_get_handle(dimm), rc);
 		ndctl_cmd_unref(cmd);
@@ -2375,7 +2375,7 @@ static int check_smart_threshold(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 		}
 
 		rc = ndctl_cmd_submit(cmd_set);
-		if (rc) {
+		if (rc < 0) {
 			fprintf(stderr, "%s: dimm: %#x failed to submit cmd_set: %d\n",
 					__func__, ndctl_dimm_get_handle(dimm), rc);
 			ndctl_cmd_unref(cmd_set);
diff --git a/test/smart-notify.c b/test/smart-notify.c
index 24e9a21..e28e0f4 100644
--- a/test/smart-notify.c
+++ b/test/smart-notify.c
@@ -22,7 +22,7 @@ static void do_notify(struct ndctl_dimm *dimm)
 	}
 
 	rc = ndctl_cmd_submit(s_cmd);
-	if (rc) {
+	if (rc < 0) {
 		fprintf(stderr, "%s: smart command failed: %d %s\n", name,
 				rc, strerror(errno));
 		goto out;
@@ -49,7 +49,7 @@ static void do_notify(struct ndctl_dimm *dimm)
 	}
 
 	rc = ndctl_cmd_submit(st_cmd);
-	if (rc) {
+	if (rc < 0) {
 		fprintf(stderr, "%s: smart threshold command failed: %d %s\n",
 				name, rc, strerror(errno));
 		goto out;
@@ -148,7 +148,7 @@ static void do_notify(struct ndctl_dimm *dimm)
 
 		ndctl_cmd_smart_threshold_set_alarm_control(sst_cmd, set_alarm);
 		rc = ndctl_cmd_submit(sst_cmd);
-		if (rc) {
+		if (rc < 0) {
 			fprintf(stderr, "%s: smart set threshold command failed: %d %s\n",
 					name, rc, strerror(errno));
 			goto out;
@@ -166,7 +166,7 @@ static void do_notify(struct ndctl_dimm *dimm)
 	}
 
 	rc = ndctl_cmd_submit(sst_cmd);
-	if (rc) {
+	if (rc < 0) {
 		fprintf(stderr, "%s: smart set threshold defaults failed: %d %s\n",
 				name, rc, strerror(errno));
 		goto out;
-- 
2.17.2
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
