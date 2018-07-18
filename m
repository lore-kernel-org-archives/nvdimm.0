Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7F5AC21BADAB2
 for <linux-nvdimm@lists.01.org>; Wed, 18 Jul 2018 10:27:38 -0700 (PDT)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH v5 09/12] nfit/libnvdimm: add support for issue secure
 erase DSM to Intel nvdimm
Date: Wed, 18 Jul 2018 17:27:27 +0000
Message-ID: <AT5PR8401MB11692A3B06A2BDB669DBEA9BAB530@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <153186061802.27463.14539931103401173743.stgit@djiang5-desk3.ch.intel.com>
 <153186089522.27463.4537738384176593789.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153186089522.27463.4537738384176593789.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
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
To: 'Dave Jiang' <dave.jiang@intel.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Cc: "dhowells@redhat.com" <dhowells@redhat.com>, "alison.schofield@intel.com" <alison.schofield@intel.com>, "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>, "keescook@chromium.org" <keescook@chromium.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of Dave Jiang
> Sent: Tuesday, July 17, 2018 3:55 PM
> Subject: [PATCH v5 09/12] nfit/libnvdimm: add support for issue secure erase DSM to Intel nvdimm
...
 +static int intel_dimm_security_erase(struct nvdimm_bus *nvdimm_bus,
> +		struct nvdimm *nvdimm, struct nvdimm_key_data *nkey)
...
> +	/* DIMM unlocked, invalidate all CPU caches before we read it */
> +	wbinvd_on_all_cpus();

For this function, that comment should use "erased" rather than
"unlocked".

For both this function and intel_dimm_security_unlock() in patch 04/12,
could the driver do a loop of clflushopts on one CPU via
clflush_cache_range() rather than run wbinvd on all CPUs?

---
Robert Elliott, HPE Persistent Memory




_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
