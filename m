Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1450603122-7205-4-git-send-email-vishal@kernel.org>
References: <1450603122-7205-1-git-send-email-vishal@kernel.org>
	<1450603122-7205-4-git-send-email-vishal@kernel.org>
Date: Wed, 23 Dec 2015 12:28:10 -0800
Message-ID: <CAPcyv4ibCPhqAm-612CvQNEeZrpSsuhw8eH5xBdJtr4BHpPZ2Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] pmem: Use the poison list to expose badblocks
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vishal Verma <vishal@kernel.org>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Vishal Verma <vishal.l.verma@intel.com>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jeff Moyer <jmoyer@redhat.com>, Linda Knippers <linda.knippers@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Dec 20, 2015 at 1:18 AM,  <vishal@kernel.org> wrote:
> From: Vishal Verma <vishal.l.verma@intel.com>
>
> Enable the gendisk badblocks feature for pmem namespaces.
> If the pmem namespace being created has any known poison associated with
> its physical address space, convert the poison ranges to bad sectors
> exposed using the badblocks interface.
>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  drivers/nvdimm/pmem.c | 124 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 124 insertions(+)
>
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 8ee7989..462570f 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
[..]
> @@ -196,6 +311,15 @@ static int pmem_attach_disk(struct device *dev,
>         set_capacity(disk, (pmem->size - pmem->data_offset) / 512);
>         pmem->pmem_disk = disk;
>
> +       ret = disk_alloc_badblocks(disk);
> +       if (ret)
> +               return ret;

I think we should skip allocating a bad block list in the case we find
no poison.  Then we can do a simple "if (disk->bb)" to check if there
are any bad blocks.
