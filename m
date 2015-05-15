Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1431448400.24419.99.camel@misato.fc.hp.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150428182551.35812.97856.stgit@dwillia2-desk3.amr.corp.intel.com>
	<1431448400.24419.99.camel@misato.fc.hp.com>
Date: Thu, 14 May 2015 17:41:58 -0700
Message-ID: <CAPcyv4hd2KP6pLEOaTBHkN0nnAcFRoCtPE0pmeJBqvpg3yGwhA@mail.gmail.com>
Subject: Re: [Linux-nvdimm] [PATCH v2 18/20] libnd: infrastructure for btt devices
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hp.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 12, 2015 at 9:33 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> On Tue, 2015-04-28 at 14:25 -0400, Dan Williams wrote:
>> Block devices from an nd bus, in addition to accepting "struct bio"
>> based requests, also have the capability to perform byte-aligned
>> accesses.  By default only the bio/block interface is used.  However, if
>> another driver can make effective use of the byte-aligned capability it
>> can claim/disable the block interface and use the byte-aligned "nd_io"
>> interface.
>>
>> The BTT driver is the intended first consumer of this mechanism to allow
>> layering atomic sector update guarantees on top of nd_io capable
>> nd-bus-block-devices.
>  :
>> +static int nd_btt_autodetect(struct nd_bus *nd_bus, struct nd_io *ndio,
>> +             struct block_device *bdev)
>> +{
>> +     char name[BDEVNAME_SIZE];
>> +     struct nd_btt *nd_btt;
>> +     struct btt_sb *btt_sb;
>> +     u64 offset, checksum;
>> +     u32 lbasize;
>> +     u8 *uuid;
>> +     int rc;
>> +
>> +     btt_sb = kzalloc(sizeof(*btt_sb), GFP_KERNEL);
>> +     if (!btt_sb)
>> +             return -ENODEV;
>> +
>> +     offset = nd_partition_offset(bdev);
>> +     rc = ndio->rw_bytes(ndio, btt_sb, offset + SZ_4K, sizeof(*btt_sb), READ);
>> +     if (rc)
>> +             goto out_free_sb;
>> +
>> +     if (get_capacity(bdev->bd_disk) < SZ_16M / 512)
>> +             goto out_free_sb;
>> +
>> +     if (memcmp(btt_sb->signature, BTT_SIG, BTT_SIG_LEN) != 0)
>> +             goto out_free_sb;
>> +
>> +     checksum = le64_to_cpu(btt_sb->checksum);
>> +     btt_sb->checksum = 0;
>> +     if (checksum != nd_btt_sb_checksum(btt_sb))
>> +             goto out_free_sb;
>> +     btt_sb->checksum = cpu_to_le64(checksum);
>> +
>> +     uuid = kmemdup(btt_sb->uuid, 16, GFP_KERNEL);
>> +     if (!uuid)
>> +             goto out_free_sb;
>> +
>> +     lbasize = le32_to_cpu(btt_sb->external_lbasize);
>> +     nd_btt = __nd_btt_create(nd_bus, lbasize, uuid);
>
> When BTT is first set up, user binds a seed "btt0" to a block device,
> such as /dev/pmem0.  It then creates /dev/nd0 bound to /dev/pmem0.
>
> After a reboot, nd_btt_autodetect() detects the BTT setup and creates a
> new "btt1" since it is called after a seed "btt0" is created.
> Therefore, it creates /dev/nd1 bound to /dev/pmem0 this time.
>
> Is this how it is intended to work, i.e. "btt0" as the default seed btt?
> While user should not rely on the name of /dev/nd%d, I thought this
> device name change was confusing...

So we can fix this to be at least as stable as the backing device
names [1], but as far as I can see we would need to start using the
backing device name in the btt device name.  A strawman proposal is to
append 's' to indicated 'sectored'.  So /dev/pmem0s is the btt
instance fronting /dev/pmem0.  Other examples:

/dev/pmem0p1s
/dev/ndblk0.0s
/dev/ndblk0.0p1s
...

Thoughts?

[1]: https://lists.01.org/pipermail/linux-nvdimm/2015-April/000636.html
