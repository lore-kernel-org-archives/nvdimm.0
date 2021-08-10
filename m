Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7A52FB6
	for <nvdimm@lists.linux.dev>; Tue, 10 Aug 2021 21:58:32 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id e15so590804plh.8
        for <nvdimm@lists.linux.dev>; Tue, 10 Aug 2021 14:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u1wijS2dhu/A+MvZm0ySzm5L7wiA+xsfZkk4lwXk4r0=;
        b=AVGDteqBnoCJ0CELNbdzSmZ1kImBZSz02nkjHEaSeOnjjSmdM7lBnhlaLzoSUEdQhG
         qvKv2QnpeP4xgCjzXnrDrHlx84QL2VlITzt2HzwS3NHO0L5O4Z2HURGUJiNXeZosNn2l
         eZCu+1Q3oSbd9L0TDOh7G/ftqDK0rPc8RcKD2g2b8yG+8uqSxzPVUB9m7E016Rmfcatu
         +wiwqN1ym/DvdAnrmtgJnmcnEGZi4NB7ulHbtYiFnx8wsuh4SGHDrczJPYPuxbA414Qk
         ZgqGTl5SSKvoTYf4fzaI9OQoO57hQrqDF2maEUdG9wsQShF04TRIA0/bvWKswZ1fi1B7
         gsIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u1wijS2dhu/A+MvZm0ySzm5L7wiA+xsfZkk4lwXk4r0=;
        b=Yo47UUBfM9RiC5k+tLbRyG17eV6DGYJW0ErjeQdXdf1crDL7Wjta62rDNA3h8ZcGYe
         i33k7C7wfTUmmjZ5OC4d+REM+Ag/6ahyyJcOts2OT485TLcrmrkuyonlqhXZiNCakLyM
         cxKOwS3UX/Cxj8kQKS5ufhumRvxtNkkgYOjL63d1CMB/BY4dQFSBS1F4vhy/FYNYQ918
         ASd2oYoWsErmsFCeujIaPlI74dNe56SIwdpUZZ/5kyHckb5pUpB32sdFvzD//+361Tea
         jQ9dw1GHUp2akImwA4x0uP4Mmahy6+4HM0NRoF2xh31B7VCSg67VtjA3MResGPlmVJ8v
         ySXg==
X-Gm-Message-State: AOAM530WDb8JcIi2z63S7ynEQfvwjbyT/Q72qk4+NLcmegMdm47mBwMl
	R896sj/Gq9UgYb7HzM7zbsuE9EZ72GVdt9fPLogenw==
X-Google-Smtp-Source: ABdhPJztK/CjgkAHDwTa1aN+OzpSbKoBVaV2wlWc6M2mwE4QwdOe+8tJGsyD9CQTLZ/PR7hklMhBw92lJkK9oPOJbxc=
X-Received: by 2002:a17:90b:23d6:: with SMTP id md22mr6913611pjb.149.1628632712004;
 Tue, 10 Aug 2021 14:58:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162854807225.1980150.1621800063058284957.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210810204345.kmrevnbd6rer5gvw@intel.com>
In-Reply-To: <20210810204345.kmrevnbd6rer5gvw@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 10 Aug 2021 14:58:20 -0700
Message-ID: <CAPcyv4iY3GDP50p0Ut0pKHQ97ZjLeGxYgk-onkmBuQ8nJO6Wyg@mail.gmail.com>
Subject: Re: [PATCH 01/23] libnvdimm/labels: Introduce getters for namespace
 label fields
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Vishal L Verma <vishal.l.verma@intel.com>, 
	"Schofield, Alison" <alison.schofield@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Aug 10, 2021 at 1:49 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> On 21-08-09 15:27:52, Dan Williams wrote:
> > In preparation for LIBNVDIMM to manage labels on CXL devices deploy
> > helpers that abstract the label type from the implementation. The CXL
> > label format is mostly similar to the EFI label format with concepts /
> > fields added, like dynamic region creation and label type guids, and
> > other concepts removed like BLK-mode and interleave-set-cookie ids.
> >
> > In addition to nsl_get_* helpers there is the nsl_ref_name() helper that
> > returns a pointer to a label field rather than copying the data.
> >
> > Where changes touch the old whitespace style, update to clang-format
> > expectations.
> >
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  drivers/nvdimm/label.c          |   20 ++++++-----
> >  drivers/nvdimm/namespace_devs.c |   70 +++++++++++++++++++--------------------
> >  drivers/nvdimm/nd.h             |   66 +++++++++++++++++++++++++++++++++++++
> >  3 files changed, 110 insertions(+), 46 deletions(-)
> >
> > diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> > index 9251441fd8a3..b6d845cfb70e 100644
> > --- a/drivers/nvdimm/label.c
> > +++ b/drivers/nvdimm/label.c
> > @@ -350,14 +350,14 @@ static bool slot_valid(struct nvdimm_drvdata *ndd,
> >               struct nd_namespace_label *nd_label, u32 slot)
> >  {
> >       /* check that we are written where we expect to be written */
> > -     if (slot != __le32_to_cpu(nd_label->slot))
> > +     if (slot != nsl_get_slot(ndd, nd_label))
> >               return false;
> >
> >       /* check checksum */
> >       if (namespace_label_has(ndd, checksum)) {
> >               u64 sum, sum_save;
> >
> > -             sum_save = __le64_to_cpu(nd_label->checksum);
> > +             sum_save = nsl_get_checksum(ndd, nd_label);
> >               nd_label->checksum = __cpu_to_le64(0);
> >               sum = nd_fletcher64(nd_label, sizeof_namespace_label(ndd), 1);
> >               nd_label->checksum = __cpu_to_le64(sum_save);
> > @@ -395,13 +395,13 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
> >                       continue;
> >
> >               memcpy(label_uuid, nd_label->uuid, NSLABEL_UUID_LEN);
> > -             flags = __le32_to_cpu(nd_label->flags);
> > +             flags = nsl_get_flags(ndd, nd_label);
> >               if (test_bit(NDD_NOBLK, &nvdimm->flags))
>
> Lazy review (didn't check NDD_NOBLK), should this be test_bit(NDD_NOBLK, &flags)?

No, there's 2 flags in play here, the label flags and the device
flags. The NDD_NOBLK device flag filters consideration of the
NSLABEL_FLAG_LOCAL label flag.

>
> >                       flags &= ~NSLABEL_FLAG_LOCAL;
> >               nd_label_gen_id(&label_id, label_uuid, flags);
> >               res = nvdimm_allocate_dpa(ndd, &label_id,
> > -                             __le64_to_cpu(nd_label->dpa),
> > -                             __le64_to_cpu(nd_label->rawsize));
> > +                                       nsl_get_dpa(ndd, nd_label),
> > +                                       nsl_get_rawsize(ndd, nd_label));
> >               nd_dbg_dpa(nd_region, ndd, res, "reserve\n");
> >               if (!res)
> >                       return -EBUSY;
> > @@ -548,9 +548,9 @@ int nd_label_active_count(struct nvdimm_drvdata *ndd)
> >               nd_label = to_label(ndd, slot);
> >
> >               if (!slot_valid(ndd, nd_label, slot)) {
> > -                     u32 label_slot = __le32_to_cpu(nd_label->slot);
> > -                     u64 size = __le64_to_cpu(nd_label->rawsize);
> > -                     u64 dpa = __le64_to_cpu(nd_label->dpa);
> > +                     u32 label_slot = nsl_get_slot(ndd, nd_label);
> > +                     u64 size = nsl_get_rawsize(ndd, nd_label);
> > +                     u64 dpa = nsl_get_dpa(ndd, nd_label);
> >
> >                       dev_dbg(ndd->dev,
> >                               "slot%d invalid slot: %d dpa: %llx size: %llx\n",
> > @@ -879,9 +879,9 @@ static struct resource *to_resource(struct nvdimm_drvdata *ndd,
> >       struct resource *res;
> >
> >       for_each_dpa_resource(ndd, res) {
> > -             if (res->start != __le64_to_cpu(nd_label->dpa))
> > +             if (res->start != nsl_get_dpa(ndd, nd_label))
> >                       continue;
> > -             if (resource_size(res) != __le64_to_cpu(nd_label->rawsize))
> > +             if (resource_size(res) != nsl_get_rawsize(ndd, nd_label))
> >                       continue;
> >               return res;
> >       }
> > diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> > index 2403b71b601e..94da804372bf 100644
> > --- a/drivers/nvdimm/namespace_devs.c
> > +++ b/drivers/nvdimm/namespace_devs.c
> > @@ -1235,7 +1235,7 @@ static int namespace_update_uuid(struct nd_region *nd_region,
> >                       if (!nd_label)
> >                               continue;
> >                       nd_label_gen_id(&label_id, nd_label->uuid,
> > -                                     __le32_to_cpu(nd_label->flags));
> > +                                     nsl_get_flags(ndd, nd_label));
> >                       if (strcmp(old_label_id.id, label_id.id) == 0)
> >                               set_bit(ND_LABEL_REAP, &label_ent->flags);
> >               }
> > @@ -1851,9 +1851,9 @@ static bool has_uuid_at_pos(struct nd_region *nd_region, u8 *uuid,
> >
> >                       if (!nd_label)
> >                               continue;
> > -                     isetcookie = __le64_to_cpu(nd_label->isetcookie);
> > -                     position = __le16_to_cpu(nd_label->position);
> > -                     nlabel = __le16_to_cpu(nd_label->nlabel);
> > +                     isetcookie = nsl_get_isetcookie(ndd, nd_label);
> > +                     position = nsl_get_position(ndd, nd_label);
> > +                     nlabel = nsl_get_nlabel(ndd, nd_label);
> >
> >                       if (isetcookie != cookie)
> >                               continue;
> > @@ -1923,8 +1923,8 @@ static int select_pmem_id(struct nd_region *nd_region, u8 *pmem_id)
> >                */
> >               hw_start = nd_mapping->start;
> >               hw_end = hw_start + nd_mapping->size;
> > -             pmem_start = __le64_to_cpu(nd_label->dpa);
> > -             pmem_end = pmem_start + __le64_to_cpu(nd_label->rawsize);
> > +             pmem_start = nsl_get_dpa(ndd, nd_label);
> > +             pmem_end = pmem_start + nsl_get_rawsize(ndd, nd_label);
> >               if (pmem_start >= hw_start && pmem_start < hw_end
> >                               && pmem_end <= hw_end && pmem_end > hw_start)
> >                       /* pass */;
> > @@ -1947,14 +1947,16 @@ static int select_pmem_id(struct nd_region *nd_region, u8 *pmem_id)
> >   * @nd_label: target pmem namespace label to evaluate
> >   */
> >  static struct device *create_namespace_pmem(struct nd_region *nd_region,
> > -             struct nd_namespace_index *nsindex,
> > -             struct nd_namespace_label *nd_label)
> > +                                         struct nd_mapping *nd_mapping,
> > +                                         struct nd_namespace_label *nd_label)
> >  {
> > +     struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> > +     struct nd_namespace_index *nsindex =
> > +             to_namespace_index(ndd, ndd->ns_current);
> >       u64 cookie = nd_region_interleave_set_cookie(nd_region, nsindex);
> >       u64 altcookie = nd_region_interleave_set_altcookie(nd_region);
> >       struct nd_label_ent *label_ent;
> >       struct nd_namespace_pmem *nspm;
> > -     struct nd_mapping *nd_mapping;
> >       resource_size_t size = 0;
> >       struct resource *res;
> >       struct device *dev;
> > @@ -1966,10 +1968,10 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
> >               return ERR_PTR(-ENXIO);
> >       }
> >
> > -     if (__le64_to_cpu(nd_label->isetcookie) != cookie) {
> > +     if (nsl_get_isetcookie(ndd, nd_label) != cookie) {
> >               dev_dbg(&nd_region->dev, "invalid cookie in label: %pUb\n",
> >                               nd_label->uuid);
> > -             if (__le64_to_cpu(nd_label->isetcookie) != altcookie)
> > +             if (nsl_get_isetcookie(ndd, nd_label) != altcookie)
> >                       return ERR_PTR(-EAGAIN);
> >
> >               dev_dbg(&nd_region->dev, "valid altcookie in label: %pUb\n",
> > @@ -2037,16 +2039,16 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
> >                       continue;
> >               }
> >
> > -             size += __le64_to_cpu(label0->rawsize);
> > -             if (__le16_to_cpu(label0->position) != 0)
> > +             ndd = to_ndd(nd_mapping);
> > +             size += nsl_get_rawsize(ndd, label0);
> > +             if (nsl_get_position(ndd, label0) != 0)
> >                       continue;
> >               WARN_ON(nspm->alt_name || nspm->uuid);
> > -             nspm->alt_name = kmemdup((void __force *) label0->name,
> > -                             NSLABEL_NAME_LEN, GFP_KERNEL);
> > +             nspm->alt_name = kmemdup(nsl_ref_name(ndd, label0),
> > +                                      NSLABEL_NAME_LEN, GFP_KERNEL);
> >               nspm->uuid = kmemdup((void __force *) label0->uuid,
> >                               NSLABEL_UUID_LEN, GFP_KERNEL);
> > -             nspm->lbasize = __le64_to_cpu(label0->lbasize);
> > -             ndd = to_ndd(nd_mapping);
> > +             nspm->lbasize = nsl_get_lbasize(ndd, label0);
> >               if (namespace_label_has(ndd, abstraction_guid))
> >                       nspm->nsio.common.claim_class
> >                               = to_nvdimm_cclass(&label0->abstraction_guid);
> > @@ -2237,7 +2239,7 @@ static int add_namespace_resource(struct nd_region *nd_region,
> >               if (is_namespace_blk(devs[i])) {
> >                       res = nsblk_add_resource(nd_region, ndd,
> >                                       to_nd_namespace_blk(devs[i]),
> > -                                     __le64_to_cpu(nd_label->dpa));
> > +                                     nsl_get_dpa(ndd, nd_label));
> >                       if (!res)
> >                               return -ENXIO;
> >                       nd_dbg_dpa(nd_region, ndd, res, "%d assign\n", count);
> > @@ -2276,7 +2278,7 @@ static struct device *create_namespace_blk(struct nd_region *nd_region,
> >               if (nd_label->isetcookie != __cpu_to_le64(nd_set->cookie2)) {
> >                       dev_dbg(ndd->dev, "expect cookie %#llx got %#llx\n",
> >                                       nd_set->cookie2,
> > -                                     __le64_to_cpu(nd_label->isetcookie));
> > +                                     nsl_get_isetcookie(ndd, nd_label));
> >                       return ERR_PTR(-EAGAIN);
> >               }
> >       }
> > @@ -2288,7 +2290,7 @@ static struct device *create_namespace_blk(struct nd_region *nd_region,
> >       dev->type = &namespace_blk_device_type;
> >       dev->parent = &nd_region->dev;
> >       nsblk->id = -1;
> > -     nsblk->lbasize = __le64_to_cpu(nd_label->lbasize);
> > +     nsblk->lbasize = nsl_get_lbasize(ndd, nd_label);
> >       nsblk->uuid = kmemdup(nd_label->uuid, NSLABEL_UUID_LEN,
> >                       GFP_KERNEL);
> >       if (namespace_label_has(ndd, abstraction_guid))
> > @@ -2296,15 +2298,14 @@ static struct device *create_namespace_blk(struct nd_region *nd_region,
> >                       = to_nvdimm_cclass(&nd_label->abstraction_guid);
> >       if (!nsblk->uuid)
> >               goto blk_err;
> > -     memcpy(name, nd_label->name, NSLABEL_NAME_LEN);
> > +     nsl_get_name(ndd, nd_label, name);
> >       if (name[0]) {
> > -             nsblk->alt_name = kmemdup(name, NSLABEL_NAME_LEN,
> > -                             GFP_KERNEL);
> > +             nsblk->alt_name = kmemdup(name, NSLABEL_NAME_LEN, GFP_KERNEL);
> >               if (!nsblk->alt_name)
> >                       goto blk_err;
> >       }
> >       res = nsblk_add_resource(nd_region, ndd, nsblk,
> > -                     __le64_to_cpu(nd_label->dpa));
> > +                     nsl_get_dpa(ndd, nd_label));
> >       if (!res)
> >               goto blk_err;
> >       nd_dbg_dpa(nd_region, ndd, res, "%d: assign\n", count);
> > @@ -2345,6 +2346,7 @@ static struct device **scan_labels(struct nd_region *nd_region)
> >       struct device *dev, **devs = NULL;
> >       struct nd_label_ent *label_ent, *e;
> >       struct nd_mapping *nd_mapping = &nd_region->mapping[0];
> > +     struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> >       resource_size_t map_end = nd_mapping->start + nd_mapping->size - 1;
> >
> >       /* "safe" because create_namespace_pmem() might list_move() label_ent */
> > @@ -2355,7 +2357,7 @@ static struct device **scan_labels(struct nd_region *nd_region)
> >
> >               if (!nd_label)
> >                       continue;
> > -             flags = __le32_to_cpu(nd_label->flags);
> > +             flags = nsl_get_flags(ndd, nd_label);
> >               if (is_nd_blk(&nd_region->dev)
> >                               == !!(flags & NSLABEL_FLAG_LOCAL))
> >                       /* pass, region matches label type */;
> > @@ -2363,9 +2365,9 @@ static struct device **scan_labels(struct nd_region *nd_region)
> >                       continue;
> >
> >               /* skip labels that describe extents outside of the region */
> > -             if (__le64_to_cpu(nd_label->dpa) < nd_mapping->start ||
> > -                 __le64_to_cpu(nd_label->dpa) > map_end)
> > -                             continue;
> > +             if (nsl_get_dpa(ndd, nd_label) < nd_mapping->start ||
> > +                 nsl_get_dpa(ndd, nd_label) > map_end)
> > +                     continue;
> >
> >               i = add_namespace_resource(nd_region, nd_label, devs, count);
> >               if (i < 0)
> > @@ -2381,13 +2383,9 @@ static struct device **scan_labels(struct nd_region *nd_region)
> >
> >               if (is_nd_blk(&nd_region->dev))
> >                       dev = create_namespace_blk(nd_region, nd_label, count);
> > -             else {
> > -                     struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> > -                     struct nd_namespace_index *nsindex;
> > -
> > -                     nsindex = to_namespace_index(ndd, ndd->ns_current);
> > -                     dev = create_namespace_pmem(nd_region, nsindex, nd_label);
> > -             }
> > +             else
> > +                     dev = create_namespace_pmem(nd_region, nd_mapping,
> > +                                                 nd_label);
> >
> >               if (IS_ERR(dev)) {
> >                       switch (PTR_ERR(dev)) {
> > @@ -2570,7 +2568,7 @@ static int init_active_labels(struct nd_region *nd_region)
> >                               break;
> >                       label = nd_label_active(ndd, j);
> >                       if (test_bit(NDD_NOBLK, &nvdimm->flags)) {
> > -                             u32 flags = __le32_to_cpu(label->flags);
> > +                             u32 flags = nsl_get_flags(ndd, label);
> >
> >                               flags &= ~NSLABEL_FLAG_LOCAL;
> >                               label->flags = __cpu_to_le32(flags);
>
> Does it make sense to introduce nsl_set_bit(), nsl_clear_bit() or some such to
> avoid this swapping between endianess?

Maybe, but that would be an independent follow-on, it's not a common
operation and CXL has no concept of BLK mode. It would just be a
cleanup for legacy code.
