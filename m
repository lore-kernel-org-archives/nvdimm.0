Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5BB3DA5D5
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 11:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386545; cv=none; b=i75en/B1ooz52gv2owEuta1ymYO7U4XnpzBTE7HdvgCmQFRxjHV0UWigijUHxCp+C4WeS5qJs5ypYxxWMs35MHomCbmKJ4YkmOXzdoTKwtkr2zzVzRLM5FnV6QZxsdodFNax735IlFmS0/H03GFjaWFQveckU+SMEteoCX+D90M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386545; c=relaxed/simple;
	bh=XYRGCI0PpLZn96DXsjLNkmeVGjCZSWKZKnuK6Ui7fm0=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=svGk35KNa+cf00rH8ywLlSyWK9O8V11sRZ1pQlmZ02IC/B05F8QNPuLhO7Cc+PjeOJ1Hzzn4iNMPMeVhy9INEU41hkXjF7R6V4ypMBGwHlxq1zaCtIE+qSNysTcJ3hBOIVoal2Dudp6Sm/SUYmQcR6UZpEorKvtle2/Tn/Hc0xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DlHbaYzR; arc=none smtp.client-ip=74.125.82.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DlHbaYzR"
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-3078e0dcd67so3092049eec.0
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 04:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782386542; x=1782991342; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=c6i9WQZ/zufg9FXTGnUqqmUX8ApC23bsNFALJTl/rt0=;
        b=DlHbaYzR9AWdPRm0qHtd9gmgz+mNuVngLfniEKcm3YTPOE/JZhco48dqFip/8LRedT
         i1yOCJzZMRXAmZStV4/oTw3Ou/vytRq3mETnn6sK8Y0y/GJsGiLtq+yV5RnZ82gq2dPJ
         DTnJ3YmigG4SWKe0jeQXqa+DfVXnLpilcExP9J4YnHa7USDgc21l0AJ3UA+tm9tzm2av
         NfakH5SM1fbtozUJ+90ruaAEmDfwShQ3qpQZCX1Sjq/CT1ZfcfYn7U4wWuHygRTkgfch
         uusXbVZqQwXLcNpWxRYXi2K3KjNP7yJeQozW5K+1WkisV8/xKNC8GVulo+vK15sL4ZsW
         jM8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782386542; x=1782991342;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c6i9WQZ/zufg9FXTGnUqqmUX8ApC23bsNFALJTl/rt0=;
        b=jOSA8dxM8/b7QngcFTTcCECv+H21/lzVVKeCjvOAKrMb8k3j+397l46iTEVhwdUGaR
         rsReWSvN73BR5syB5Mt4BGFD3XmQ8KTAarZdipc5TTRkEJ0mI4rQMJkPf873iHgENGPL
         edv9EyO+REqAGHijnxHQkoX/YfYPcdgPygHZx3wSGhX/ueDhDdHxS8b1N85ghKkX9kBW
         ke7YqKzwL06U1lLDBOE/0rzpDLD8BLpPWcrj5H1u7xjL+RDL3m4SzOCR06UMqyEz7JNW
         jd8bJ7DYevYNO8ASKWeQDR6fX3IB1C0nIYQ3AzwpoWm1HXKHZVS5Zr6UYZS7mo3epwYx
         Oq6A==
X-Forwarded-Encrypted: i=1; AHgh+RoC42s2O+nYfYXHkQ2AdvJb5ufJM/ywxY/Yf4Oypd5luWDLP7GJSkfgrxfwghW8XQ9NZBthi9U=@lists.linux.dev
X-Gm-Message-State: AOJu0YxkLmMj09QSS1sGoB8TLJJx8NWrRSOPOcFymUunhLtM+5TYkI9X
	WyyLgiTajbRif0xH0Mf9rzd8ykTH5+w7Nf66ASmncWKIuVWt+10J8E8+
X-Gm-Gg: AfdE7cnNhVbBqaD2UWoNHhjpuyuuSbEJDNWmD/zZk37w09h2VUWLSJthJyZhAqVFlsN
	M/yvtbcEa8G65PY/CGTlMpMyJj1POAT51QU0hevbukP18/4w06zaNXCaJ70cg6aIRKWnLvFngCN
	1xKfkmGEhYdUgDw0xNtAAgg2zSNAuXKPeaTYbB7Xc6mmtXnqVSP9YbfPAt6hHmVYeo9HhdsMebe
	x2uE4vWKIjWPG2G82pt5bfOej10ST2JLS+W3NBPAD2+Rebjh8q90O57HdyS0OyTj34Z1yjvMEtV
	Yc7oWo1LSoaPAQgDPKe/YlDMiJFgapa7axYdkjUUGQPEZk2dHd2n+hn+kY6esoDTsmwJxu4T0E5
	cGUeQ+LbYZ6Zeidfnp8NLB/Kh7lfhuH1PlBALtl5tqinMe05bHtT5DSR3sPPAOirwXw/D1UXxcZ
	qejb1xkJx+ncyCa+Z76xutVowKa2ORF3RVAmbCkCK2yHmvnMJnJI9wPLs7zEhJ8viijJw4
X-Received: by 2002:a05:7300:fb8d:b0:304:b14:ec53 with SMTP id 5a478bee46e88-30c84dab521mr2310208eec.27.1782386541222;
        Thu, 25 Jun 2026 04:22:21 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c8c02a2a2sm4473498eec.2.2026.06.25.04.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 04:22:20 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Thu, 25 Jun 2026 04:22:18 -0700
To: Dave Jiang <dave.jiang@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@groves.net>, Gregory Price <gourry@gourry.net>,
	Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH v10 30/31] tools/testing/cxl: Add DC Regions to mock mem
 data
Message-ID: <aj0Pah7Mu4OnFvAY@AnisaLaptop.localdomain>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <b8aa5ccbb32745a1ec53b81c72b670ed05557691.1779528761.git.anisa.su@samsung.com>
 <a82c78ca-a944-44e4-a634-6d3dbdcbfe42@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a82c78ca-a944-44e4-a634-6d3dbdcbfe42@intel.com>

On Fri, May 29, 2026 at 04:42:46PM -0700, Dave Jiang wrote:
> 
> 
> On 5/23/26 2:43 AM, Anisa Su wrote:
> > From: Ira Weiny <ira.weiny@intel.com>
> > 
> > cxl_test provides a good way to ensure quick smoke and regression
> > testing.  The complexity of Dynamic Capacity (DC) extent processing as
> > well as the complexity of DC-backed DAX regions can mostly be tested
> > through cxl_test.  This includes management of DC regions and DAX
> > devices on those regions; the management of extent device lifetimes;
> > and the processing of DCD events.
> > 
> > The only missing functionality from this test is actual interrupt
> > processing.
> > 
> > Mock memory devices can easily mock DC information and manage fake
> > extent data.
> > 
> > Define mock_dc_partition information within the mock memory data.  Add
> > sysfs entries on the mock device to inject and delete extents.
> > 
> > The inject format is <start>:<length>:<tag>:<more>[:<seq>] where <tag>
> > is a UUID string (or "" / "0" for the null UUID) and <seq> is an
> > optional shared_extn_seq value used for sharable-partition tests
> > (defaults to 0).
> > The delete format is <start>:<length>:<uuid>
> > 
> > Directly call the event irq callback to simulate irqs to process the
> > test extents.
> > 
> > Add DC mailbox commands to the CEL and implement those commands.
> > 
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > Signed-off-by: Anisa Su <anisa.su@samsung.com>
> > 
> > ---
> > Changes:
> > [anisa: add uuid + shared_extn_seq, align mock with kernel validators,
> >         introduce a sharable-partition test fixture]
> > [anisa: replace "sparse" terminology with "DC" / "DC-backed"]
> > 
> > Carry a uuid_t and a u16 shared_extn_seq on each mock extent, parse
> > tags via uuid_parse() in the inject path and the pre-extent fixture,
> > and propagate both fields through log_dc_event() and
> > mock_get_dc_extent_list().  An optional 5th field in the inject
> > format supplies the shared_extn_seq for sharable-partition tests.
> > The delete format takes the uuid as its third field so release
> > events carry tag identity to the host.
> > 
> > Mock fixes required to satisfy the host-side validators:
> > 
> >   - dsmad_handle starts at 0xFA, not 0xFADE.  The Get Dynamic
> >     Capacity Configuration response's DSMAD Handle field is 1 byte
> >     per the CXL spec; the kernel rejects any handle with the upper
> >     24 bits non-zero as a firmware-bug.
> > 
> >   - dc_accept_extent() treats a re-accept of an already-accepted
> >     extent as a successful no-op (look up dc_accepted_exts when the
> >     sent xa lookup misses).  The host replays accepts for pre-
> >     injected extents on region creation; without this the existing-
> >     extent ingest aborts with -ENOMEM.
> > 
> >   - __dc_del_extent_store() runs strim() on the trailing uuid field
> >     so the '
> > ' shell write tail doesn't cause parse_tag() to fall
> >     through to uuid_parse() and -EINVAL.
> > 
> >   - NUM_MOCK_DC_REGIONS reduced from 2 to 1.  The host's
> >     cxl_dev_dc_identify() surfaces partitions[0] only, so extents
> >     seeded into a second mock partition land outside the registered
> >     DC range; for tagged groups that also trips the partition-
> >     equality gate and drops the whole group (including the in-range
> >     member).
> > 
> > Sharable-partition test fixture:
> > 
> >   - Stamp MOCK_DC_SHARABLE_SERIAL (0xDCDC) on the cxl_mem instance
> >     at pdev->id == 0.  The companion cxl_test driver checks this
> >     serial in mock_cxl_endpoint_parse_cdat() and sets the DC
> >     partition's perf.shareable on that memdev only — exposing both
> >     sharable and non-sharable DC partitions from one cxl_test
> >     module load so the userspace suite can exercise both regimes.
> > 
> >   - Skip inject_prev_extents() on that one memdev: the pre-injected
> >     extents are untagged / seq=0 and would be rejected as firmware-
> >     bug by cxl_validate_extent() on a sharable partition, leaving
> >     spurious noise in dmesg at probe.
> > ---
> >  tools/testing/cxl/test/cxl.c |  21 +
> >  tools/testing/cxl/test/mem.c | 806 ++++++++++++++++++++++++++++++++++-
> >  2 files changed, 826 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
> > index 418669927fb0..ac6060ede061 100644
> > --- a/tools/testing/cxl/test/cxl.c
> > +++ b/tools/testing/cxl/test/cxl.c
> > @@ -18,6 +18,15 @@ static int interleave_arithmetic;
> >  static bool extended_linear_cache;
> >  static bool fail_autoassemble;
> >  
> > +/*
> > + * Mock serial sentinel.  The cxl_mock_mem probe stamps this serial on
> > + * exactly one platform device (cxl_mem with id 0); that single memdev's
> > + * DC partition is marked sharable below in mock_cxl_endpoint_parse_cdat
> > + * so the suite can exercise sharable-extent code paths without losing
> > + * the non-sharable coverage on the other mock memdevs.
> > + */
> > +#define MOCK_DC_SHARABLE_SERIAL 0xDCDCULL
> 
> This is defined in cxl.c and mem.c. Why not just put it in a shared header?
> 
Moved to mock.h

> > +
> >  #define FAKE_QTG_ID	42
> >  
> >  #define NR_CXL_HOST_BRIDGES 2
> > @@ -1432,6 +1441,18 @@ static void mock_cxl_endpoint_parse_cdat(struct cxl_port *port)
> >  		};
> >  
> >  		dpa_perf_setup(port, &range, perf);
> > +
> > +		/*
> > +		 * The mock probe stamps MOCK_DC_SHARABLE_SERIAL onto exactly
> > +		 * one cxl_mem instance; mark its DC partition sharable so
> > +		 * cxl_validate_extent() routes shared-seq injects through
> > +		 * the sharable regime.  Every other memdev keeps its DC
> > +		 * partition non-sharable so the existing untagged / seq=0
> > +		 * tests still run on this kernel.
> > +		 */
> > +		if (cxlds->part[i].mode == CXL_PARTMODE_DYNAMIC_RAM_A &&
> > +		    cxlds->serial == MOCK_DC_SHARABLE_SERIAL)
> > +			perf->shareable = true;
> >  	}
> >  
> >  	cxl_memdev_update_perf(cxlmd);
> > diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
> > index fe1dadddd18e..9cc97b718b5f 100644
> > --- a/tools/testing/cxl/test/mem.c
> > +++ b/tools/testing/cxl/test/mem.c
> > @@ -20,6 +20,7 @@
> >  #define FW_SLOTS 3
> >  #define DEV_SIZE SZ_2G
> >  #define EFFECT(x) (1U << x)
> > +#define BASE_DYNAMIC_CAP_DPA DEV_SIZE
> >  
> >  #define MOCK_INJECT_DEV_MAX 8
> >  #define MOCK_INJECT_TEST_MAX 128
> > @@ -113,6 +114,22 @@ static struct cxl_cel_entry mock_cel[] = {
> >  				      EFFECT(SECURITY_CHANGE_IMMEDIATE) |
> >  				      EFFECT(BACKGROUND_OP)),
> >  	},
> > +	{
> > +		.opcode = cpu_to_le16(CXL_MBOX_OP_GET_DC_CONFIG),
> > +		.effect = CXL_CMD_EFFECT_NONE,
> > +	},
> > +	{
> > +		.opcode = cpu_to_le16(CXL_MBOX_OP_GET_DC_EXTENT_LIST),
> > +		.effect = CXL_CMD_EFFECT_NONE,
> > +	},
> > +	{
> > +		.opcode = cpu_to_le16(CXL_MBOX_OP_ADD_DC_RESPONSE),
> > +		.effect = cpu_to_le16(EFFECT(CONF_CHANGE_IMMEDIATE)),
> > +	},
> > +	{
> > +		.opcode = cpu_to_le16(CXL_MBOX_OP_RELEASE_DC),
> > +		.effect = cpu_to_le16(EFFECT(CONF_CHANGE_IMMEDIATE)),
> > +	},
> >  };
> >  
> >  /* See CXL 2.0 Table 181 Get Health Info Output Payload */
> > @@ -173,6 +190,16 @@ struct vendor_test_feat {
> >  	__le32 data;
> >  } __packed;
> >  
> > +/*
> > + * The kernel surfaces only the first DC partition reported by the
> > + * device (cxl_dev_dc_identify() takes partitions[0] only), so any
> > + * extents we pre-inject into a second mock partition end up rejected
> > + * as "not in a valid DC partition" — and for tagged groups they also
> > + * trip the partition-equality gate and drop the whole group (including
> > + * the in-range member in DC0).  Keep the mock at one DC partition.
> > + */
> > +#define NUM_MOCK_DC_REGIONS 1
> > +
> >  struct cxl_mockmem_data {
> >  	void *lsa;
> >  	void *fw;
> > @@ -191,6 +218,20 @@ struct cxl_mockmem_data {
> >  	unsigned long sanitize_timeout;
> >  	struct vendor_test_feat test_feat;
> >  	u8 shutdown_state;
> > +
> > +	struct cxl_dc_partition dc_partitions[NUM_MOCK_DC_REGIONS];
> > +	u32 dc_ext_generation;
> > +	struct mutex ext_lock;
> > +
> > +	/*
> > +	 * Extents are in 1 of 3 states
> > +	 * FM (sysfs added but not sent to the host yet)
> > +	 * sent (sent to the host but not accepted)
> > +	 * accepted (by the host)
> > +	 */
> > +	struct xarray dc_fm_extents;
> > +	struct xarray dc_sent_extents;
> > +	struct xarray dc_accepted_exts;
> >  };
> >  
> >  static struct mock_event_log *event_find_log(struct device *dev, int log_type)
> > @@ -607,6 +648,229 @@ static void cxl_mock_event_trigger(struct device *dev)
> >  	cxl_mem_get_event_records(mdata->mds, mes->ev_status);
> >  }
> >  
> > +struct cxl_extent_data {
> > +	u64 dpa_start;
> > +	u64 length;
> > +	uuid_t uuid;
> > +	u16 shared_extn_seq;
> > +	bool shared;
> > +};
> > +
> > +/*
> > + * Parse a tag string into a uuid_t.  Accepts the empty string and "0"
> > + * as shorthand for the null UUID; anything else must be a UUID string
> > + * uuid_parse() can understand.
> > + */
> > +static int parse_tag(const char *tag, uuid_t *out)
> > +{
> > +	if (!tag || tag[0] == '\0' || strcmp(tag, "0") == 0) {
> > +		uuid_copy(out, &uuid_null);
> > +		return 0;
> > +	}
> > +	return uuid_parse(tag, out);
> > +}
> > +
> > +static int __devm_add_extent(struct device *dev, struct xarray *array,
> > +			     u64 start, u64 length, const char *tag,
> > +			     u16 shared_extn_seq, bool shared)
> > +{
> > +	struct cxl_extent_data *extent;
> > +	int rc;
> > +
> > +	extent = devm_kzalloc(dev, sizeof(*extent), GFP_KERNEL);
> > +	if (!extent)
> > +		return -ENOMEM;
> > +
> > +	extent->dpa_start = start;
> > +	extent->length = length;
> > +	rc = parse_tag(tag, &extent->uuid);
> > +	if (rc) {
> > +		dev_err(dev, "Failed to parse tag '%s'\n", tag);
> > +		devm_kfree(dev, extent);
> > +		return rc;
> > +	}
> > +	extent->shared_extn_seq = shared_extn_seq;
> > +	extent->shared = shared;
> > +
> > +	if (xa_insert(array, start, extent, GFP_KERNEL)) {
> > +		devm_kfree(dev, extent);
> > +		dev_err(dev, "Failed xarry insert %#llx\n", start);
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int devm_add_fm_extent(struct device *dev, u64 start, u64 length,
> > +			      const char *tag, u16 shared_extn_seq, bool shared)
> > +{
> > +	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
> > +
> > +	guard(mutex)(&mdata->ext_lock);
> > +	return __devm_add_extent(dev, &mdata->dc_fm_extents, start, length,
> > +				 tag, shared_extn_seq, shared);
> > +}
> > +
> > +static int dc_accept_extent(struct device *dev, u64 start, u64 length)
> > +{
> > +	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
> > +	struct cxl_extent_data *ext;
> > +
> > +	dev_dbg(dev, "Host accepting extent %#llx\n", start);
> > +	mdata->dc_ext_generation++;
> 
> Should this only happen after xa_load() succeeds and checked?
> 
Yes, moved after the if (!ext || ...)
> > +
> > +	lockdep_assert_held(&mdata->ext_lock);
> 
> Maybe this should go above the increment above
> 
lockdep_assert_held moved up to top of function.

> > +	ext = xa_load(&mdata->dc_sent_extents, start);
> > +	if (!ext || ext->length != length) {
> > +		/*
> > +		 * The host may re-accept extents we already moved into the
> > +		 * accepted xarray (e.g. pre-injected extents replayed on
> > +		 * region creation).  Treat that as a successful no-op so
> > +		 * the existing-extent ingest path doesn't abort.
> > +		 */
> > +		ext = xa_load(&mdata->dc_accepted_exts, start);
> > +		if (ext && ext->length == length)
> > +			return 0;
> > +		dev_err(dev, "Extent %#llx-%#llx not found\n",
> > +			start, start + length);
> > +		return -ENOMEM;
> > +	}
> > +	xa_erase(&mdata->dc_sent_extents, start);
> > +	return xa_insert(&mdata->dc_accepted_exts, start, ext, GFP_KERNEL);
> > +}
> > +
> > +static void release_dc_ext(void *md)
> > +{
> > +	struct cxl_mockmem_data *mdata = md;
> > +
> > +	xa_destroy(&mdata->dc_fm_extents);
> > +	xa_destroy(&mdata->dc_sent_extents);
> > +	xa_destroy(&mdata->dc_accepted_exts);
> > +}
> > +
> > +/* Pretend to have some previous accepted extents */
> > +struct pre_ext_info {
> > +	u64 offset;
> > +	u64 length;
> > +	const char *tag;
> > +} pre_ext_info[] = {
> > +	{
> > +		.offset = SZ_128M,
> > +		.length = SZ_64M,
> > +		.tag = "",
> > +	},
> > +	{
> > +		.offset = SZ_256M,
> > +		.length = SZ_64M,
> > +		.tag = "deadbeef-cafe-baad-f00d-fedcba987654",
> > +	},
> > +};
> > +
> > +static int devm_add_sent_extent(struct device *dev, u64 start, u64 length,
> > +				const char *tag, u16 shared_extn_seq, bool shared)
> > +{
> > +	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
> > +
> > +	lockdep_assert_held(&mdata->ext_lock);
> > +	return __devm_add_extent(dev, &mdata->dc_sent_extents, start, length,
> > +				 tag, shared_extn_seq, shared);
> > +}
> > +
> > +static int inject_prev_extents(struct device *dev, u64 base_dpa)
> > +{
> > +	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
> > +	int rc;
> > +
> > +	dev_dbg(dev, "Adding %ld pre-extents for testing\n",
> > +		ARRAY_SIZE(pre_ext_info));
> > +
> > +	guard(mutex)(&mdata->ext_lock);
> > +	for (int i = 0; i < ARRAY_SIZE(pre_ext_info); i++) {
> > +		u64 ext_dpa = base_dpa + pre_ext_info[i].offset;
> > +		u64 ext_len = pre_ext_info[i].length;
> > +
> > +		dev_dbg(dev, "Adding pre-extent DPA:%#llx LEN:%#llx tag:%s\n",
> > +			ext_dpa, ext_len, pre_ext_info[i].tag);
> > +
> > +		rc = devm_add_sent_extent(dev, ext_dpa, ext_len,
> > +					  pre_ext_info[i].tag, 0, false);
> > +		if (rc) {
> > +			dev_err(dev, "Failed to add pre-extent DPA:%#llx LEN:%#llx; %d\n",
> > +				ext_dpa, ext_len, rc);
> > +			return rc;
> > +		}
> > +
> > +		rc = dc_accept_extent(dev, ext_dpa, ext_len);
> > +		if (rc)
> > +			return rc;
> > +	}
> > +	return 0;
> > +}
> > +
> > +static int cxl_mock_dc_partition_setup(struct device *dev)
> > +{
> > +	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
> > +	u64 base_dpa = BASE_DYNAMIC_CAP_DPA;
> > +	u32 dsmad_handle = 0xFA;
> > +	u64 decode_length = SZ_512M;
> > +	u64 block_size = SZ_512;
> > +	u64 length = SZ_512M;
> > +	int rc;
> > +
> > +	mutex_init(&mdata->ext_lock);
> > +	xa_init(&mdata->dc_fm_extents);
> > +	xa_init(&mdata->dc_sent_extents);
> > +	xa_init(&mdata->dc_accepted_exts);
> > +
> > +	rc = devm_add_action_or_reset(dev, release_dc_ext, mdata);
> > +	if (rc)
> > +		return rc;
> > +
> > +	for (int i = 0; i < NUM_MOCK_DC_REGIONS; i++) {
> > +		struct cxl_dc_partition *part = &mdata->dc_partitions[i];
> > +
> > +		dev_dbg(dev, "Creating DC partition DC%d DPA:%#llx LEN:%#llx\n",
> > +			i, base_dpa, length);
> > +
> > +		part->base = cpu_to_le64(base_dpa);
> > +		part->decode_length = cpu_to_le64(decode_length /
> > +						  CXL_CAPACITY_MULTIPLIER);
> > +		part->length = cpu_to_le64(length);
> > +		part->block_size = cpu_to_le64(block_size);
> > +		part->dsmad_handle = cpu_to_le32(dsmad_handle);
> > +		dsmad_handle++;
> > +
> > +		/*
> > +		 * Skip pre-injection on the sharable mock memdev.  The
> > +		 * pre-injected extents are untagged / seq=0, which a
> > +		 * sharable partition rejects as firmware-bug; leaving the
> > +		 * sharable memdev with an empty DC partition is what its
> > +		 * dedicated tests (test_shared_extent_inject and
> > +		 * test_seq_integrity_gap in cxl-dcd.sh) expect anyway.
> > +		 *
> > +		 * The sharable fixture is the memdev at pdev->id == 0 —
> > +		 * see the matching MOCK_DC_SHARABLE_SERIAL stamp in
> > +		 * cxl_mock_mem_probe().  This relies on tools/testing/cxl
> > +		 * always allocating a "cxl_mem" platform device with id 0
> > +		 * as the first memdev; if that invariant ever breaks the
> > +		 * sharable test fixture will land on the wrong device.
> > +		 */
> > +		if (to_platform_device(dev)->id != 0) {
> > +			rc = inject_prev_extents(dev, base_dpa);
> > +			if (rc) {
> > +				dev_err(dev,
> > +					"Failed to add pre-extents for DC%d\n",
> > +					i);
> > +				return rc;
> > +			}
> > +		}
> > +
> > +		base_dpa += decode_length;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  static int mock_gsl(struct cxl_mbox_cmd *cmd)
> >  {
> >  	if (cmd->size_out < sizeof(mock_gsl_payload))
> > @@ -1582,6 +1846,193 @@ static int mock_get_supported_features(struct cxl_mockmem_data *mdata,
> >  	return 0;
> >  }
> >  
> > +static int mock_get_dc_config(struct device *dev,
> > +			      struct cxl_mbox_cmd *cmd)
> > +{
> > +	struct cxl_mbox_get_dc_config_in *dc_config = cmd->payload_in;
> > +	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
> > +	u8 partition_requested, partition_start_idx, partition_ret_cnt;
> > +	struct cxl_mbox_get_dc_config_out *resp;
> > +	int i;
> > +
> > +	partition_requested = min(dc_config->partition_count, NUM_MOCK_DC_REGIONS);
> > +
> > +	if (cmd->size_out < struct_size(resp, partition, partition_requested))
> > +		return -EINVAL;
> > +
> > +	memset(cmd->payload_out, 0, cmd->size_out);
> > +	resp = cmd->payload_out;
> > +
> > +	partition_start_idx = dc_config->start_partition_index;
> > +	partition_ret_cnt = 0;
> > +	for (i = 0; i < NUM_MOCK_DC_REGIONS; i++) {
> > +		if (i >= partition_start_idx) {
> 
> Should there be a check for partition_requested and exit when reached?
> 
changed loop condition to i < NUM_MOCK_DC_REGIONS && partition_ret_cnt < partition_requested;
> > +			memcpy(&resp->partition[partition_ret_cnt],
> > +				&mdata->dc_partitions[i],
> > +				sizeof(resp->partition[partition_ret_cnt]));
> > +			partition_ret_cnt++;
> > +		}
> > +	}
> > +	resp->avail_partition_count = NUM_MOCK_DC_REGIONS;
> > +	resp->partitions_returned = i;
> 
> partition returned always return NUM_MOCK_DC_REGIONS. Never takes into account partition_start_idx.
> 
fixed: resp->partitions_returned = partition_ret_cnt;

> > +
> > +	dev_dbg(dev, "Returning %d dc partitions\n", partition_ret_cnt);
> > +	return 0;
> > +}
> > +
> > +static int mock_get_dc_extent_list(struct device *dev,
> > +				   struct cxl_mbox_cmd *cmd)
> > +{
> > +	struct cxl_mbox_get_extent_out *resp = cmd->payload_out;
> > +	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
> > +	struct cxl_mbox_get_extent_in *get = cmd->payload_in;
> > +	u32 total_avail = 0, total_ret = 0;
> > +	struct cxl_extent_data *ext;
> > +	u32 ext_count, start_idx;
> > +	unsigned long i;
> > +
> > +	ext_count = le32_to_cpu(get->extent_cnt);
> > +	start_idx = le32_to_cpu(get->start_extent_index);
> > +
> > +	memset(resp, 0, sizeof(*resp));
> > +
> > +	guard(mutex)(&mdata->ext_lock);
> > +	/*
> > +	 * Total available needs to be calculated and returned regardless of
> > +	 * how many can actually be returned.
> > +	 */
> > +	xa_for_each(&mdata->dc_accepted_exts, i, ext)
> > +		total_avail++;
> > +
> > +	if (start_idx > total_avail)
> > +		return -EINVAL;
> > +
> > +	xa_for_each(&mdata->dc_accepted_exts, i, ext) {
> > +		if (total_ret >= ext_count)
> > +			break;
> > +
> > +		if (total_ret >= start_idx) {
> 
> In the case where start_idx > 0, I think we hit an infinite loop.
> 
Added var idx, which always increments:

if (idx++ >= start_idx) { ...

> > +			resp->extent[total_ret].start_dpa =
> > +						cpu_to_le64(ext->dpa_start);
> > +			resp->extent[total_ret].length =
> > +						cpu_to_le64(ext->length);
> > +			export_uuid(resp->extent[total_ret].uuid, &ext->uuid);
> > +			resp->extent[total_ret].shared_extn_seq =
> > +						cpu_to_le16(ext->shared_extn_seq);
> > +			total_ret++;
> > +		}
> > +	}
> > +
> > +	resp->returned_extent_count = cpu_to_le32(total_ret);
> > +	resp->total_extent_count = cpu_to_le32(total_avail);
> > +	resp->generation_num = cpu_to_le32(mdata->dc_ext_generation);
> > +
> > +	dev_dbg(dev, "Returning %d extents of %d total\n",
> > +		total_ret, total_avail);
> > +
> > +	return 0;
> > +}
> > +
> > +static void dc_clear_sent(struct device *dev)
> > +{
> > +	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
> > +	struct cxl_extent_data *ext;
> > +	unsigned long index;
> > +
> > +	lockdep_assert_held(&mdata->ext_lock);
> > +
> > +	/* Any extents not accepted must be cleared */
> > +	xa_for_each(&mdata->dc_sent_extents, index, ext) {
> > +		dev_dbg(dev, "Host rejected extent %#llx\n", ext->dpa_start);
> > +		xa_erase(&mdata->dc_sent_extents, ext->dpa_start);
> > +	}
> > +}
> > +
> > +static int mock_add_dc_response(struct device *dev,
> > +				struct cxl_mbox_cmd *cmd)
> > +{
> > +	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
> > +	struct cxl_mbox_dc_response *req = cmd->payload_in;
> > +	u32 list_size = le32_to_cpu(req->extent_list_size);
> > +
> > +	guard(mutex)(&mdata->ext_lock);
> > +	for (int i = 0; i < list_size; i++) {
> > +		u64 start = le64_to_cpu(req->extent_list[i].dpa_start);
> > +		u64 length = le64_to_cpu(req->extent_list[i].length);
> > +		int rc;
> > +
> > +		rc = dc_accept_extent(dev, start, length);
> > +		if (rc)
> > +			return rc;
> > +	}
> 
> mock response seems to be missing ordering check. CXL r4.0 8.2.10.9.9.3 requires ADD_DC_RESPONSE to be sent in same order as the Add Capacity Event Records or return invalid input.
> 
ordering check added

> > +
> > +	dc_clear_sent(dev);
> > +	return 0;
> > +}
> > +
> > +static void dc_delete_extent(struct device *dev, unsigned long long start,
> > +			     unsigned long long length)
> > +{
> > +	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
> > +	unsigned long long end = start + length;
> > +	struct cxl_extent_data *ext;
> > +	unsigned long index;
> > +
> > +	dev_dbg(dev, "Deleting extent at %#llx len:%#llx\n", start, length);
> > +
> > +	guard(mutex)(&mdata->ext_lock);
> > +	xa_for_each(&mdata->dc_fm_extents, index, ext) {
> > +		u64 extent_end = ext->dpa_start + ext->length;
> > +
> > +		/*
> > +		 * Any extent which 'touches' the released delete range will be
> > +		 * removed.
> > +		 */
> > +		if ((start <= ext->dpa_start && ext->dpa_start < end) ||
> > +		    (start <= extent_end && extent_end < end))
> 
> would this work?
> if (start < extent_end && ext->dpa_start < end)
> 
Yeah I think so
> 
> > +			xa_erase(&mdata->dc_fm_extents, ext->dpa_start);
> > +	}
> > +
> > +	/*
> > +	 * If the extent was accepted let it be for the host to drop
> > +	 * later.
> > +	 */
> > +}
> > +
> > +static int release_accepted_extent(struct device *dev, u64 start, u64 length)
> > +{
> > +	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
> > +	struct cxl_extent_data *ext;
> > +
> > +	guard(mutex)(&mdata->ext_lock);
> > +	ext = xa_load(&mdata->dc_accepted_exts, start);
> > +	if (!ext || ext->length != length) {
> > +		dev_err(dev, "Extent %#llx not in accepted state\n", start);
> > +		return -EINVAL;
> > +	}
> > +	xa_erase(&mdata->dc_accepted_exts, start);
> > +	mdata->dc_ext_generation++;
> > +
> > +	return 0;
> > +}
> > +
> > +static int mock_dc_release(struct device *dev,
> > +			   struct cxl_mbox_cmd *cmd)
> > +{
> > +	struct cxl_mbox_dc_response *req = cmd->payload_in;
> > +	u32 list_size = le32_to_cpu(req->extent_list_size);
> > +
> > +	for (int i = 0; i < list_size; i++) {
> > +		u64 start = le64_to_cpu(req->extent_list[i].dpa_start);
> > +		u64 length = le64_to_cpu(req->extent_list[i].length);
> > +
> > +		dev_dbg(dev, "Extent %#llx released by host\n", start);
> > +		release_accepted_extent(dev, start, length);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  static int cxl_mock_mbox_send(struct cxl_mailbox *cxl_mbox,
> >  			      struct cxl_mbox_cmd *cmd)
> >  {
> > @@ -1673,6 +2124,18 @@ static int cxl_mock_mbox_send(struct cxl_mailbox *cxl_mbox,
> >  	case CXL_MBOX_OP_GET_SUPPORTED_FEATURES:
> >  		rc = mock_get_supported_features(mdata, cmd);
> >  		break;
> > +	case CXL_MBOX_OP_GET_DC_CONFIG:
> > +		rc = mock_get_dc_config(dev, cmd);
> > +		break;
> > +	case CXL_MBOX_OP_GET_DC_EXTENT_LIST:
> > +		rc = mock_get_dc_extent_list(dev, cmd);
> > +		break;
> > +	case CXL_MBOX_OP_ADD_DC_RESPONSE:
> > +		rc = mock_add_dc_response(dev, cmd);
> > +		break;
> > +	case CXL_MBOX_OP_RELEASE_DC:
> > +		rc = mock_dc_release(dev, cmd);
> > +		break;
> >  	case CXL_MBOX_OP_GET_FEATURE:
> >  		rc = mock_get_feature(mdata, cmd);
> >  		break;
> > @@ -1739,6 +2202,14 @@ static void init_event_log(struct mock_event_log *log)
> >  	log->last_handle = 1;
> >  }
> >  
> > +/*
> > + * Stamp this serial on a single mock cxl_mem instance so the
> > + * companion cxl_test driver can find it and mark its DC partition
> > + * sharable in mock_cxl_endpoint_parse_cdat().  Must match the value
> > + * defined in tools/testing/cxl/test/cxl.c.
> > + */
> > +#define MOCK_DC_SHARABLE_SERIAL 0xDCDCULL
> > +
> >  static int cxl_mock_mem_probe(struct platform_device *pdev)
> >  {
> >  	struct device *dev = &pdev->dev;
> > @@ -1758,6 +2229,10 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
> >  		return -ENOMEM;
> >  	dev_set_drvdata(dev, mdata);
> >  
> > +	rc = cxl_mock_dc_partition_setup(dev);
> > +	if (rc)
> > +		return rc;
> > +
> >  	mdata->lsa = vmalloc(LSA_SIZE);
> >  	if (!mdata->lsa)
> >  		return -ENOMEM;
> > @@ -1774,7 +2249,23 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
> >  	if (rc)
> >  		return rc;
> >  
> > -	mds = cxl_memdev_state_create(dev, pdev->id + 1, 0);
> > +	{
> > +		u64 serial = pdev->id + 1;
> > +
> > +		/*
> > +		 * Reserve the memdev at pdev->id == 0 as the sharable DC
> > +		 * partition test fixture.  This relies on tools/testing/cxl
> > +		 * always allocating a "cxl_mem" platform device with id 0
> > +		 * as the first memdev — currently true in cxl.c, but if
> > +		 * the topology ever renumbers, the sharable serial will be
> > +		 * stamped on the wrong device (or no device).  Matched by
> > +		 * the skip-pre-inject guard in cxl_mock_dc_partition_setup
> > +		 * and by mock_cxl_endpoint_parse_cdat in cxl_test.
> > +		 */
> > +		if (pdev->id == 0)
> > +			serial = MOCK_DC_SHARABLE_SERIAL;
> > +		mds = cxl_memdev_state_create(dev, serial, 0);
> > +	}
> 
> Would prefer not have inline anonymous block. Just declare the var at top.
> 
> >  	if (IS_ERR(mds))
> >  		return PTR_ERR(mds);
> >  
> > @@ -1814,6 +2305,9 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
> >  	if (rc)
> >  		return rc;
> >  
> > +	if (cxl_dcd_supported(mds))
> > +		cxl_configure_dcd(mds, &range_info);
> > +
> >  	rc = cxl_dpa_setup(cxlds, &range_info);
> >  	if (rc)
> >  		return rc;
> > @@ -1921,11 +2415,321 @@ static ssize_t sanitize_timeout_store(struct device *dev,
> >  
> >  static DEVICE_ATTR_RW(sanitize_timeout);
> >  
> > +/* Return if the proposed extent would break the test code */
> > +static bool new_extent_valid(struct device *dev, size_t new_start,
> > +			     size_t new_len)
> > +{
> > +	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
> > +	struct cxl_extent_data *extent;
> > +	size_t new_end, i;
> > +
> > +	if (!new_len)
> > +		return false;
> > +
> > +	new_end = new_start + new_len;
> > +
> > +	dev_dbg(dev, "New extent %zx-%zx\n", new_start, new_end);
> > +
> > +	guard(mutex)(&mdata->ext_lock);
> > +	dev_dbg(dev, "Checking extents starts...\n");
> > +	xa_for_each(&mdata->dc_fm_extents, i, extent) {
> > +		if (extent->dpa_start == new_start)
> > +			return false;
> > +	}
> > +
> > +	dev_dbg(dev, "Checking sent extents starts...\n");
> > +	xa_for_each(&mdata->dc_sent_extents, i, extent) {
> > +		if (extent->dpa_start == new_start)
> > +			return false;
> > +	}
> > +
> > +	dev_dbg(dev, "Checking accepted extents starts...\n");
> > +	xa_for_each(&mdata->dc_accepted_exts, i, extent) {
> > +		if (extent->dpa_start == new_start)
> > +			return false;
> > +	}
> > +
> > +	return true;
> > +}
> > +
> > +struct cxl_test_dcd {
> > +	uuid_t id;
> > +	struct cxl_event_dcd rec;
> > +} __packed;
> > +
> > +struct cxl_test_dcd dcd_event_rec_template = {
> > +	.id = CXL_EVENT_DC_EVENT_UUID,
> > +	.rec = {
> > +		.hdr = {
> > +			.length = sizeof(struct cxl_test_dcd),
> > +		},
> > +	},
> > +};
> > +
> > +static int log_dc_event(struct cxl_mockmem_data *mdata, enum dc_event type,
> > +			u64 start, u64 length, const char *tag_str,
> > +			u16 shared_extn_seq, bool more)
> > +{
> > +	struct device *dev = mdata->mds->cxlds.dev;
> > +	struct cxl_test_dcd *dcd_event;
> > +	uuid_t tag;
> > +	int rc;
> > +
> > +	dev_dbg(dev, "mock device log event %d\n", type);
> > +
> > +	dcd_event = devm_kmemdup(dev, &dcd_event_rec_template,
> > +				     sizeof(*dcd_event), GFP_KERNEL);
> > +	if (!dcd_event)
> > +		return -ENOMEM;
> > +
> > +	dcd_event->rec.flags = 0;
> > +	if (more)
> > +		dcd_event->rec.flags |= CXL_DCD_EVENT_MORE;
> > +	dcd_event->rec.event_type = type;
> > +	dcd_event->rec.extent.start_dpa = cpu_to_le64(start);
> > +	dcd_event->rec.extent.length = cpu_to_le64(length);
> > +	rc = parse_tag(tag_str, &tag);
> > +	if (rc) {
> > +		devm_kfree(dev, dcd_event);
> > +		return rc;
> > +	}
> > +	export_uuid(dcd_event->rec.extent.uuid, &tag);
> > +	dcd_event->rec.extent.shared_extn_seq = cpu_to_le16(shared_extn_seq);
> > +
> > +	mes_add_event(mdata, CXL_EVENT_TYPE_DCD,
> > +		      (struct cxl_event_record_raw *)dcd_event);
> > +
> > +	/* Fake the irq */
> > +	cxl_mem_get_event_records(mdata->mds, CXLDEV_EVENT_STATUS_DCD);
> > +
> > +	return 0;
> > +}
> > +
> > +static void mark_extent_sent(struct device *dev, unsigned long long start)
> > +{
> > +	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
> > +	struct cxl_extent_data *ext;
> > +
> > +	guard(mutex)(&mdata->ext_lock);
> > +	ext = xa_erase(&mdata->dc_fm_extents, start);
> > +	if (xa_insert(&mdata->dc_sent_extents, ext->dpa_start, ext, GFP_KERNEL))
> > +		dev_err(dev, "Failed to mark extent %#llx sent\n", ext->dpa_start);
> 
> Should it also clean up 'ext' since insert failed?
> 
> DJ
> > +}
> > +
> > +/*
> > + * Format <start>:<length>:<tag>:<more_flag>
> > + *
> > + * start and length must be a multiple of the configured partition block size.
> > + * Tag can be any string up to 16 bytes.
> > + *
> > + * Extents must be exclusive of other extents
> > + *
> > + * If the more flag is specified it is expected that an additional extent will
> > + * be specified without the more flag to complete the test transaction with the
> > + * host.
> > + */
> > +static ssize_t __dc_inject_extent_store(struct device *dev,
> > +					struct device_attribute *attr,
> > +					const char *buf, size_t count,
> > +					bool shared)
> > +{
> > +	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
> > +	unsigned long long start, length, more;
> > +	char *len_str, *uuid_str, *more_str, *seq_str;
> > +	u16 shared_extn_seq = 0;
> > +	size_t buf_len = count;
> > +	int rc;
> > +
> > +	char *start_str __free(kfree) = kstrdup(buf, GFP_KERNEL);
> > +	if (!start_str)
> > +		return -ENOMEM;
> > +
> > +	len_str = strnchr(start_str, buf_len, ':');
> > +	if (!len_str) {
> > +		dev_err(dev, "Extent failed to find len_str: %s\n", start_str);
> > +		return -EINVAL;
> > +	}
> > +
> > +	*len_str = '\0';
> > +	len_str += 1;
> > +	buf_len -= strlen(start_str);
> > +
> > +	uuid_str = strnchr(len_str, buf_len, ':');
> > +	if (!uuid_str) {
> > +		dev_err(dev, "Extent failed to find uuid_str: %s\n", len_str);
> > +		return -EINVAL;
> > +	}
> > +	*uuid_str = '\0';
> > +	uuid_str += 1;
> > +
> > +	more_str = strnchr(uuid_str, buf_len, ':');
> > +	if (!more_str) {
> > +		dev_err(dev, "Extent failed to find more_str: %s\n", uuid_str);
> > +		return -EINVAL;
> > +	}
> > +	*more_str = '\0';
> > +	more_str += 1;
> > +
> > +	/* Optional 5th field: shared_extn_seq.  Absent -> 0. */
> > +	seq_str = strnchr(more_str, buf_len, ':');
> > +	if (seq_str) {
> > +		unsigned long long seq;
> > +
> > +		*seq_str = '\0';
> > +		seq_str += 1;
> > +		if (kstrtoull(seq_str, 0, &seq) || seq > U16_MAX) {
> > +			dev_err(dev, "Extent failed to parse seq: %s\n",
> > +				seq_str);
> > +			return -EINVAL;
> > +		}
> > +		shared_extn_seq = seq;
> > +	}
> > +
> > +	if (kstrtoull(start_str, 0, &start)) {
> > +		dev_err(dev, "Extent failed to parse start: %s\n", start_str);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (kstrtoull(len_str, 0, &length)) {
> > +		dev_err(dev, "Extent failed to parse length: %s\n", len_str);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (kstrtoull(more_str, 0, &more)) {
> > +		dev_err(dev, "Extent failed to parse more: %s\n", more_str);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (!new_extent_valid(dev, start, length))
> > +		return -EINVAL;
> > +
> > +	rc = devm_add_fm_extent(dev, start, length, uuid_str, shared_extn_seq,
> > +				shared);
> > +	if (rc) {
> > +		dev_err(dev, "Failed to add extent DPA:%#llx LEN:%#llx; %d\n",
> > +			start, length, rc);
> > +		return rc;
> > +	}
> > +
> > +	mark_extent_sent(dev, start);
> > +	rc = log_dc_event(mdata, DCD_ADD_CAPACITY, start, length, uuid_str,
> > +			  shared_extn_seq, more);
> > +	if (rc) {
> > +		dev_err(dev, "Failed to add event %d\n", rc);
> > +		return rc;
> > +	}
> > +
> > +	return count;
> > +}
> > +
> > +static ssize_t dc_inject_extent_store(struct device *dev,
> > +				      struct device_attribute *attr,
> > +				      const char *buf, size_t count)
> > +{
> > +	return __dc_inject_extent_store(dev, attr, buf, count, false);
> > +}
> > +static DEVICE_ATTR_WO(dc_inject_extent);
> > +
> > +static ssize_t dc_inject_shared_extent_store(struct device *dev,
> > +					     struct device_attribute *attr,
> > +					     const char *buf, size_t count)
> > +{
> > +	return __dc_inject_extent_store(dev, attr, buf, count, true);
> > +}
> > +static DEVICE_ATTR_WO(dc_inject_shared_extent);
> > +
> > +static ssize_t __dc_del_extent_store(struct device *dev,
> > +				     struct device_attribute *attr,
> > +				     const char *buf, size_t count,
> > +				     enum dc_event type)
> > +{
> > +	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
> > +	unsigned long long start, length;
> > +	char *len_str, *uuid_str;
> > +	size_t buf_len = count;
> > +	int rc;
> > +
> > +	char *start_str __free(kfree) = kstrdup(buf, GFP_KERNEL);
> > +	if (!start_str)
> > +		return -ENOMEM;
> > +
> > +	len_str = strnchr(start_str, buf_len, ':');
> > +	if (!len_str) {
> > +		dev_err(dev, "Failed to find len_str: %s\n", start_str);
> > +		return -EINVAL;
> > +	}
> > +	*len_str = '\0';
> > +	len_str += 1;
> > +	buf_len -= strlen(start_str);
> > +
> > +	uuid_str = strnchr(len_str, buf_len, ':');
> > +	if (!uuid_str) {
> > +		dev_err(dev, "Failed to find uuid_str: %s\n", len_str);
> > +		return -EINVAL;
> > +	}
> > +	*uuid_str = '\0';
> > +	uuid_str += 1;
> > +	/*
> > +	 * uuid_str is the trailing field; trim shell-added '\n' so
> > +	 * parse_tag()/uuid_parse() see a clean string.
> > +	 */
> > +	uuid_str = strim(uuid_str);
> > +
> > +	if (kstrtoull(start_str, 0, &start)) {
> > +		dev_err(dev, "Failed to parse start: %s\n", start_str);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (kstrtoull(len_str, 0, &length)) {
> > +		dev_err(dev, "Failed to parse length: %s\n", len_str);
> > +		return -EINVAL;
> > +	}
> > +
> > +	dc_delete_extent(dev, start, length);
> > +
> > +	if (type == DCD_FORCED_CAPACITY_RELEASE)
> > +		dev_dbg(dev, "Forcing delete of extent %#llx len:%#llx\n",
> > +			start, length);
> > +
> > +	rc = log_dc_event(mdata, type, start, length, uuid_str, 0, false);
> > +	if (rc) {
> > +		dev_err(dev, "Failed to add event %d\n", rc);
> > +		return rc;
> > +	}
> > +
> > +	return count;
> > +}
> > +
> > +/*
> > + * Format <start>:<length>:<uuid>
> > + */
> > +static ssize_t dc_del_extent_store(struct device *dev,
> > +				   struct device_attribute *attr,
> > +				   const char *buf, size_t count)
> > +{
> > +	return __dc_del_extent_store(dev, attr, buf, count,
> > +				     DCD_RELEASE_CAPACITY);
> > +}
> > +static DEVICE_ATTR_WO(dc_del_extent);
> > +
> > +static ssize_t dc_force_del_extent_store(struct device *dev,
> > +					 struct device_attribute *attr,
> > +					 const char *buf, size_t count)
> > +{
> > +	return __dc_del_extent_store(dev, attr, buf, count,
> > +				     DCD_FORCED_CAPACITY_RELEASE);
> > +}
> > +static DEVICE_ATTR_WO(dc_force_del_extent);
> > +
> >  static struct attribute *cxl_mock_mem_attrs[] = {
> >  	&dev_attr_security_lock.attr,
> >  	&dev_attr_event_trigger.attr,
> >  	&dev_attr_fw_buf_checksum.attr,
> >  	&dev_attr_sanitize_timeout.attr,
> > +	&dev_attr_dc_inject_extent.attr,
> > +	&dev_attr_dc_inject_shared_extent.attr,
> > +	&dev_attr_dc_del_extent.attr,
> > +	&dev_attr_dc_force_del_extent.attr,
> >  	NULL
> >  };
> >  ATTRIBUTE_GROUPS(cxl_mock_mem);
> 
