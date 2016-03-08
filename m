Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ob0-x22e.google.com (mail-ob0-x22e.google.com
 [IPv6:2607:f8b0:4003:c01::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B0E4E1A1E85
 for <linux-nvdimm@lists.01.org>; Mon,  7 Mar 2016 18:21:42 -0800 (PST)
Received: by mail-ob0-x22e.google.com with SMTP id fp4so1574012obb.2
 for <linux-nvdimm@lists.01.org>; Mon, 07 Mar 2016 18:21:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1457391787.15454.399.camel@hpe.com>
References: <1457108082-4610-1-git-send-email-toshi.kani@hpe.com>
 <CAPcyv4g8+6LBW08JZ3Ym0mAuo1bcwjGTeHrzS0p=QoJb4Mqeag@mail.gmail.com>
 <1457391787.15454.399.camel@hpe.com>
Date: Mon, 7 Mar 2016 18:21:28 -0800
Message-ID: <CAPcyv4jA+Lvg6L5WKijg_=xHo-DX-tp14bBtbAoonzcv0a5JcA@mail.gmail.com>
Subject: Re: [PATCH v2-UPDATE 3/4] resource: Add device-managed
 insert/remove_resource()
From: Dan Williams <dan.j.williams@intel.com>
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@suse.de>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 7, 2016 at 3:03 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
> On Mon, 2016-03-07 at 10:14 -0800, Dan Williams wrote:
>  :
>> > +/**
>> > + * devm_insert_resource() - insert an I/O or memory resource
>> > + * @dev: device for which to produce the resource
>> > + * @root: root of the resource tree
>> > + * @new: descriptor of the new resource
>> > + *
>> > + * This is a device-managed version of insert_resource(). There is
>> > usually
>> > + * no need to release resources requested by this function explicitly
>> > since
>> > + * that will be taken care of when the device is unbound from its bus
>> > driver.
>> > + * If for some reason the resource needs to be released explicitly,
>> > because
>> > + * of ordering issues for example, bus drivers must call
>> > devm_remove_resource()
>> > + * rather than the regular remove_resource().
>> > + *
>> > + * devm_insert_resource() is intended for producers of resources, such
>> > as
>> > + * FW modules and bus drivers.
>> > + *
>> > + * Returns 0 on success or a negative error code on failure.
>> > + */
>> > +int devm_insert_resource(struct device *dev, struct resource *root,
>> > +                         struct resource *new)
>> > +{
>> > +       struct resource **ptr;
>> > +       int ret;
>> > +
>> > +       ptr = devres_alloc(__devm_remove_resource, sizeof(*ptr),
>> > GFP_KERNEL);
>> > +       if (!ptr)
>> > +               return -ENOMEM;
>> > +
>> > +       *ptr = new;
>> > +
>> > +       ret = insert_resource(root, new);
>> > +       if (ret) {
>> > +               dev_err(dev, "unable to insert resource: %pR (%d)\n",
>> > new, ret);
>> > +               devres_free(ptr);
>> > +               return -EBUSY;
>> > +       }
>> > +
>> > +       devres_add(dev, ptr);
>> > +       return 0;
>> > +}
>> > +EXPORT_SYMBOL_GPL(devm_insert_resource);
>>
>> The only hesitation I have with this is that the kernel has gotten by
>> a long time without allowing external modules to insert resources.  If
>> keeping it private all this time was purposeful then maybe we should
>> make this new NVDIMM-need to call insert_resource() private to the
>> nfit driver and built-in-only.
>
> Here is some background info on this:
>
> - External modules can already insert resources via platform_device_add(),
> which is used for inserting resources that may not be enumerated by
> standard FW interfaces.  There are over 200 callers already.
>
> - PCI mmcfg driver and ACPI HPET driver find their resources from ACPI, and
> call insert_resource() to insert them, which is similar to what this
> patchset tries to do with ACPI NFIT.  Both PCI and HPET drivers do not
> support unloading, however.
>   # cat /proc/iomem
>    :
>   80000000-8fffffff : PCI MMCONFIG 0000 [bus 00-ff]
>     80000000-8fffffff : reserved
>    :
>   fed00000-fed003ff : HPET 0
>     fed00000-fed003ff : PNP0103:00
>
> - Existing FW modules and bus drivers using insert_resource() are built-
> into the kernel, and insert_resource() is not exported.  I think this is
> because these modules did not have to (or may not) support unloading.
>
> - Both the NFIT driver and NVDIMM bus drivers are new and support
> unloading.  This calls for an exported interface for insert_resource().
>
> - devm impl of insert/remove_resource() is added to assure that resources
> are properly released on unloading.  Exporting devm interfaces makes sense
> (to me).
>
> - However, devm_insert/remove_resource() should not be confused with
> devm_request/release_resource().  Hence, this patchset adds comments to
> clarify that they are used for producers of resources.  The same comments
> are added to insert/remove_resource() as well.
>

Thanks Toshi, this satisfies my concerns.  Ingo, any concern with me
taking this series through the nvdimm tree since it touches the nfit
driver?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
