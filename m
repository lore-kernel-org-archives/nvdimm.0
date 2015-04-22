Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [Linux-nvdimm] [PATCH 19/21] nd: infrastructure for btt devices
Date: Wed, 22 Apr 2015 19:12:18 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295A8BE89F@G9W0745.americas.hpqcorp.net>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150418013655.25237.41353.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150418013655.25237.41353.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of
> Dan Williams
> Sent: Friday, April 17, 2015 8:37 PM
> To: linux-nvdimm@lists.01.org
> Subject: [Linux-nvdimm] [PATCH 19/21] nd: infrastructure for btt devices
> 
...
> +/*
> + * btt_sb_checksum: compute checksum for btt info block
> + *
> + * Returns a fletcher64 checksum of everything in the given info block
> + * except the last field (since that's where the checksum lives).
> + */
> +u64 btt_sb_checksum(struct btt_sb *btt_sb)
> +{
> +	u64 sum, sum_save;
> +
> +	sum_save = btt_sb->checksum;
> +	btt_sb->checksum = 0;
> +	sum = nd_fletcher64(btt_sb, sizeof(*btt_sb));
> +	btt_sb->checksum = sum_save;
> +	return sum;
> +}
> +EXPORT_SYMBOL(btt_sb_checksum);
...

Of all the functions with prototypes in nd.h, this is the only 
function that doesn't have a name starting with nd_.

Following such a convention helps ease setting up ftrace filters.

---
Robert Elliott, HP Server Storage

