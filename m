Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295A8BE89F@G9W0745.americas.hpqcorp.net>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150418013655.25237.41353.stgit@dwillia2-desk3.amr.corp.intel.com>
	<94D0CD8314A33A4D9D801C0FE68B40295A8BE89F@G9W0745.americas.hpqcorp.net>
Date: Wed, 22 Apr 2015 12:39:49 -0700
Message-ID: <CAPcyv4goF0X5P4ZDnNiucn18urgmayJxe_zOfXituuBMk_h+GQ@mail.gmail.com>
Subject: Re: [Linux-nvdimm] [PATCH 19/21] nd: infrastructure for btt devices
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 22, 2015 at 12:12 PM, Elliott, Robert (Server Storage)
<Elliott@hp.com> wrote:
>> -----Original Message-----
>> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of
>> Dan Williams
>> Sent: Friday, April 17, 2015 8:37 PM
>> To: linux-nvdimm@lists.01.org
>> Subject: [Linux-nvdimm] [PATCH 19/21] nd: infrastructure for btt devices
>>
> ...
>> +/*
>> + * btt_sb_checksum: compute checksum for btt info block
>> + *
>> + * Returns a fletcher64 checksum of everything in the given info block
>> + * except the last field (since that's where the checksum lives).
>> + */
>> +u64 btt_sb_checksum(struct btt_sb *btt_sb)
>> +{
>> +     u64 sum, sum_save;
>> +
>> +     sum_save = btt_sb->checksum;
>> +     btt_sb->checksum = 0;
>> +     sum = nd_fletcher64(btt_sb, sizeof(*btt_sb));
>> +     btt_sb->checksum = sum_save;
>> +     return sum;
>> +}
>> +EXPORT_SYMBOL(btt_sb_checksum);
> ...
>
> Of all the functions with prototypes in nd.h, this is the only
> function that doesn't have a name starting with nd_.
>
> Following such a convention helps ease setting up ftrace filters.

Sure, I'll fix that up.
