Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5128003E
	for <nvdimm@lists.linux.dev>; Tue,  6 Feb 2024 06:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707199235; cv=none; b=ITPiMnrgqlrQGIbo8GtmUWXg9cUUxVuxsaaqO3BUG1uhA76flkk0AXn6A3089ow9qi3NaGE4x99oaeBcwFU0jXwujgZfnD/R4Q1xLfSaQSfqpsMMxMOUeNcWT9GHO6pfaM4mqHelvgagmdC0OrJ8lQoz3CUh0CZfav31cfc40GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707199235; c=relaxed/simple;
	bh=W8rnBkBIGpaOnQ8Y2AHw2CUQsx0YHv6wU9Zu6cU1Sok=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=Y99k97gytzn2oxFvT0wf6jzZ/mAf5SXds6KtvAKZsVbOystAb+oe2iBZFVZZDGgxEdSlsFIi67gLhljius+4RC/XLf2y14mM08PKJ2wyF2HOoYdWI+xeIz8oOKkT60U6kC0en+NX3NOLcSEmdLdZmnD33eWI5dTDJaVV23rQJZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=KanfOoxL; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="KanfOoxL"
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240206060029epoutp04238bb1a0ec52ca8a837246d5da15b6b8~xMKdlJplh2690026900epoutp04O
	for <nvdimm@lists.linux.dev>; Tue,  6 Feb 2024 06:00:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240206060029epoutp04238bb1a0ec52ca8a837246d5da15b6b8~xMKdlJplh2690026900epoutp04O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1707199229;
	bh=XLqrTgZ2CyGx3OpZr4zo1V2fISRTESqEN6UpgjvjUj4=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=KanfOoxLHLcJ24oy+49WbKKTiuRYupcJsJtam3hFdpQY66YZYem4czWMKNVXvNEvx
	 PMJADaTkbTtaYHEFL1DhebHkEaKMHPdikGdihm9e6twDF8CNVs0K62HA6mNu1ST2oj
	 FJEanp6dn+p3TrQ/wR5ynri8W8Vp9yE/dLEBv/x8=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTP id
	20240206060028epcas2p2df262557fd5feec14e3db0a379ef9559~xMKdF5odO0742907429epcas2p22;
	Tue,  6 Feb 2024 06:00:28 +0000 (GMT)
Received: from epsmgec2p1-new.samsung.com (unknown [182.195.36.97]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4TTXfN0vL0z4x9QR; Tue,  6 Feb
	2024 06:00:28 +0000 (GMT)
X-AuditID: b6c32a4d-9f7ff70000004a32-3d-65c1cafc7e4a
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmgec2p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E5.99.18994.CFAC1C56; Tue,  6 Feb 2024 15:00:28 +0900 (KST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Subject: RE: [NDCTL PATCH v5 3/4] ndctl: cxl: add QoS class check for CXL
 region creation
Reply-To: wj28.lee@samsung.com
Sender: Wonjae Lee <wj28.lee@samsung.com>
From: Wonjae Lee <wj28.lee@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>, Alison Schofield
	<alison.schofield@intel.com>, KyungSan Kim <ks0204.kim@samsung.com>, Hojin
	Nam <hj96.nam@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20240201230646.1328211-4-dave.jiang@intel.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20240206060027epcms2p4291072d19a247b4b2c3944b5e6e8ed24@epcms2p4>
Date: Tue, 06 Feb 2024 15:00:27 +0900
X-CMS-MailID: 20240206060027epcms2p4291072d19a247b4b2c3944b5e6e8ed24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnk+LIzCtJLcpLzFFi42LZdljTTPfPqYOpBgfWsFjcfXyBzeLEzUY2
	iw9v/rFYHN3DYXF+1ikWi5U//rBa3JpwjMmB3WPxnpdMHi82z2T06NuyitHj8ya5AJaobJuM
	1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoAOUFMoSc0qB
	QgGJxcVK+nY2RfmlJakKGfnFJbZKqQUpOQXmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZP//1
	MRbs161oWvWOsYHxk1IXIyeHhICJxLGLW5m6GLk4hAT2MEqsu/WWuYuRg4NXQFDi7w5hkBph
	gWiJhr0tLCC2kICcxN3bp5gg4poSb6atAouzCahL/Og8CTZHRGAqo8S1lnlgDrPAVkaJRS++
	skJs45WY0f6UBcKWlti+fCsjiM0pYCNxe/E5qBoNiR/LepkhbFGJm6vfssPY74/NZ4SwRSRa
	752FqhGUePBzN1RcSuLrib/sIIslBJoZJVYf62eFcBoYJTpmHobarC/ReP09G4jNK+Ar0by0
	F8xmEVCVaLvbDTXJReLBxzVgm5kF5CW2v50DDhZmoJ/X79IHMSUElCWO3GKBqOCT6Dj8lx3m
	xx3znjBB2EoSU9qOQE2UkGho3MoGYXtITPl0hXECo+IsRFjPQrJrFsKuBYzMqxilUguKc9NT
	k40KDHXzUsvhUZycn7uJEZwitXx3ML5e/1fvECMTB+MhRgkOZiURXrMdB1KFeFMSK6tSi/Lj
	i0pzUosPMZoCfTqRWUo0OR+YpPNK4g1NLA1MzMwMzY1MDcyVxHnvtc5NERJITyxJzU5NLUgt
	gulj4uCUamBqTC2ozogUqj5jyq7wMOrzNScTq8CLL0/d+R/6p/La/7OXXjaFLn9c/PkG77l+
	84W6KqeypF/M2jml5nKNJH/bm+zd/3IOlj9doyNw7VxaT9VikYDUZTmcLlv2u1scdv7U+5Gh
	KMJRYeUcPaEvakt/bLkXm9T++8bP6K1t5m8nL33gsyHto+qsd3NDvq5R0+5KCp6qNC9z9lnW
	L84stZNklORDdgt0TCw/kfhLLO+fss6WZ49W57xYcVOW/dHcs2sCVNSSxSaeONzW43DWjCXw
	fnGto/n7uGlf1h0xvZB2gZP75R4rs/IpQksrtjatTG9J9DeUDKrsX63R5H7uUzpDzE7Ohjsv
	WWMOB9pNVJuhxFKckWioxVxUnAgAVSxNGxoEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240201230708epcas2p4d6ec80b002940637fa0d97e78d43442f
References: <20240201230646.1328211-4-dave.jiang@intel.com>
	<20240201230646.1328211-1-dave.jiang@intel.com>
	<CGME20240201230708epcas2p4d6ec80b002940637fa0d97e78d43442f@epcms2p4>

On Thu, Feb 01, 2024 at 04:05:06PM -0700, Dave Jiang wrote:
> The CFMWS provides a QTG ID. The kernel driver creates a root decoder that
> represents the CFMWS. A qos_class attribute is exported via sysfs for the root
> decoder.
>
> One or more QoS class tokens are retrieved via QTG ID _DSM from the ACPI0017
> device for a CXL memory device. The input for the _DSM is the read and write
> latency and bandwidth for the path between the device and the CPU. The
> numbers are constructed by the kernel driver for the _DSM input. When a
> device is probed, QoS class tokens  are retrieved. This is useful for a
> hot-plugged CXL memory device that does not have regions created.
>
> Add a QoS check during region creation. Emit a warning if the qos_class
> token from the root decoder is different than the mem device qos_class
> token. User parameter options are provided to fail instead of just
> warning.
>
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  Documentation/cxl/cxl-create-region.txt |  9 ++++
>  cxl/region.c                            | 56 ++++++++++++++++++++++++-
>  2 files changed, 64 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/cxl/cxl-create-region.txt b/Documentation/cxl/cxl-create-region.txt
> index f11a412bddfe..d5e34cf38236 100644
> --- a/Documentation/cxl/cxl-create-region.txt
> +++ b/Documentation/cxl/cxl-create-region.txt
> @@ -105,6 +105,15 @@ include::bus-option.txt[]
>   supplied, the first cross-host bridge (if available), decoder that
>   supports the largest interleave will be chosen.
>
> +-e::
> +--strict::
> + Enforce strict execution where any potential error will force failure.
> + For example, if qos_class mismatches region creation will fail.
> +
> +-q::
> +--no-enforce-qos::
> + Parameter to bypass qos_class mismatch failure. Will only emit warning.
> +
>  include::human-option.txt[]
>
>  include::debug-option.txt[]
> diff --git a/cxl/region.c b/cxl/region.c
> index 3a762db4800e..f9033fa0afbf 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -32,6 +32,8 @@ static struct region_params {
>   bool force;
>   bool human;
>   bool debug;
> + bool strict;
> + bool no_qos;
>  } param = {
>   .ways = INT_MAX,
>   .granularity = INT_MAX,
> @@ -49,6 +51,8 @@ struct parsed_params {
>   const char **argv;
>   struct cxl_decoder *root_decoder;
>   enum cxl_decoder_mode mode;
> + bool strict;
> + bool no_qos;
>  };
>
>  enum region_actions {
> @@ -81,7 +85,9 @@ OPT_STRING('U', "uuid", &param.uuid, \
>      "region uuid", "uuid for the new region (default: autogenerate)"), \
>  OPT_BOOLEAN('m', "memdevs", &param.memdevs, \
>       "non-option arguments are memdevs"), \
> -OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats")
> +OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats"), \
> +OPT_BOOLEAN('e', "strict", &param.strict, "strict execution enforcement"), \
> +OPT_BOOLEAN('q', "no-enforce-qos", &param.no_qos, "no enforce of qos_class")
>
>  static const struct option create_options[] = {
>   BASE_OPTIONS(),
> @@ -360,6 +366,9 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
>       }
>   }
>
> + p->strict = param.strict;
> + p->no_qos = param.no_qos;
> +
>   return 0;
>
>  err:
> @@ -467,6 +476,49 @@ static void set_type_from_decoder(struct cxl_ctx *ctx, struct parsed_params *p)
>       p->mode = CXL_DECODER_MODE_PMEM;
>  }
>
> +static int create_region_validate_qos_class(struct cxl_ctx *ctx,
> +                     struct parsed_params *p)
> +{
> + int root_qos_class;
> + int qos_class;
> + int i;
> +
> + root_qos_class = cxl_root_decoder_get_qos_class(p->root_decoder);
> + if (root_qos_class == CXL_QOS_CLASS_NONE)
> +     return 0;
> +
> + for (i = 0; i < p->ways; i++) {
> +     struct json_object *jobj =
> +         json_object_array_get_idx(p->memdevs, i);
> +     struct cxl_memdev *memdev = json_object_get_userdata(jobj);
> +
> +     if (p->mode == CXL_DECODER_MODE_RAM)
> +         qos_class = cxl_memdev_get_ram_qos_class(memdev);
> +     else
> +         qos_class = cxl_memdev_get_pmem_qos_class(memdev);
> +
> +     /* No qos_class entries. Possibly no kernel support */
> +     if (qos_class == CXL_QOS_CLASS_NONE)
> +         break;
> +
> +     if (qos_class != root_qos_class) {
> +         if (p->strict && !p->no_qos) {
> +             log_err(&rl, "%s QoS Class mismatches %s\n",
> +                 cxl_decoder_get_devname(p->root_decoder),
> +                 cxl_memdev_get_devname(memdev));
> +
> +             return -ENXIO;
> +         }
> +
> +         log_notice(&rl, "%s QoS Class mismatches %s\n",
> +                cxl_decoder_get_devname(p->root_decoder),
> +                cxl_memdev_get_devname(memdev));
> +     }
> + }
> +
> + return 0;
> +}
> +
>  static int create_region_validate_config(struct cxl_ctx *ctx,
>                    struct parsed_params *p)
>  {
> @@ -507,6 +559,8 @@ found:
>       return rc;
>
>   collect_minsize(ctx, p);
> + create_region_validate_qos_class(ctx, p);

Hello,

IIUC, if the strict option is given and a qos class mismatch occurs,
the region creation should fail. To do that, shouldn't the return
value of create_region_validate_qos_class() be handled like below?

diff --git a/cxl/region.c b/cxl/region.c
index f9033fa..0468f5f 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -559,7 +559,9 @@ found:
                return rc;

        collect_minsize(ctx, p);
-       create_region_validate_qos_class(ctx, p);
+       rc = create_region_validate_qos_class(ctx, p);
+       if (rc)
+               return rc;

        return 0;
 }

Thanks,
Wonjae
