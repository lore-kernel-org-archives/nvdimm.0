Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63D96D18
	for <nvdimm@lists.linux.dev>; Thu, 12 Aug 2021 22:33:33 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id mq2-20020a17090b3802b0290178911d298bso13092643pjb.1
        for <nvdimm@lists.linux.dev>; Thu, 12 Aug 2021 15:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3yFJEywMadOnjjGiSS8HCobEBBxNlw5a7Z76oVs1fjM=;
        b=M4fAnhlFRfIHArektmHn7mqb+E4s+HF/+f8cvMd98ZfO4LdeKjV+vwLKBFQFDc6gjf
         xzN3yxYX8bKnr333CJ+3BhWsOenyCcuLmeNPP/uPPF47X92VNfKgx7BrE+1+pZGdNQpx
         Dmm+fj6rC/X7lHBmgXyj1GxMjQad1rRw3jcY9P6JFQf55liGsVHHWakT4TaKQHJ+LyrG
         Ps7bXXpOV5oeGvGBJsAGNkriYSwmaRcSank8Bl48si75/vxL8sKlPgx6gfJyXFqW1nSw
         QyJ2PTn3fyhDkgd2tlMyWp28Ms3tErJAyAsuTL9G78hC41db0tAoi7D8G4qf1TrJEr9G
         21jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3yFJEywMadOnjjGiSS8HCobEBBxNlw5a7Z76oVs1fjM=;
        b=DZKnnB2Umpw3lNziTx65rsXCFCGUWVzRMrVwYLssiiTQsP8MKSYMixAa6VtiO980Fn
         2fp/MzXKfWLm7fX6wJlM1TNiA3x+xAiZBRxMis6fXEAVOKCbvnXRnh8y7qvvF9cpjrrp
         kXgw6gqH61zwjljZpVdxTBg7dtvJoR4PtWyprTF75Ivs4Awck9dbhTTGN7OM2h8/uCai
         r81b2LjhbGh9gtlNeUGmYcGVzZrF15Vc7M1jRM3Cu3aaQraxqkemboutQanUXtS+bVOm
         2H/+jyoN7tlJcg4OheHI5VH/WTi8xlRgXAsivRmJTZaIswRxwObYuYGSGE5hKpbg29I/
         HelQ==
X-Gm-Message-State: AOAM530YYA6tK1GU49B3BipomtNYyWgq52Vz3GwVCehkBFUHk5BVa05A
	l4yQNy8do9q9OxgNNibzyML9hhBYf4Hc6OkP9w8Fdw==
X-Google-Smtp-Source: ABdhPJzN8pEgNS4I+6vBCrq2+cZb0M21vLe1jNrk42nSRkkSGdb/fCbAMjS2UP2TlDz1+1qfRe4VlABEGeVD9tkoMR0=
X-Received: by 2002:a05:6a00:16c6:b029:32d:e190:9dd0 with SMTP id
 l6-20020a056a0016c6b029032de1909dd0mr6155068pfc.70.1628807612982; Thu, 12 Aug
 2021 15:33:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162854812073.1980150.8157116233571368158.stgit@dwillia2-desk3.amr.corp.intel.com>
 <YROE48iCZNFaDcSo@smile.fi.intel.com> <YRQB9Yvh3tmT9An4@smile.fi.intel.com>
 <CAPcyv4jOEfi=RJTeOFTbvkBB+Khfzi5QirrhPxeM4J2bQXRYiQ@mail.gmail.com> <YRQik5OnRyYQAm4o@smile.fi.intel.com>
In-Reply-To: <YRQik5OnRyYQAm4o@smile.fi.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 12 Aug 2021 15:34:59 -0700
Message-ID: <CAPcyv4hY9YL7MhkeSu4GYBNo6hbeMRgqnKf8YuLuQ3khSbhn9A@mail.gmail.com>
Subject: Re: [PATCH 10/23] libnvdimm/labels: Add uuid helpers
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Ben Widawsky <ben.widawsky@intel.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, "Schofield, Alison" <alison.schofield@intel.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Aug 11, 2021 at 12:18 PM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> On Wed, Aug 11, 2021 at 10:11:56AM -0700, Dan Williams wrote:
> > On Wed, Aug 11, 2021 at 9:59 AM Andy Shevchenko
> > <andriy.shevchenko@linux.intel.com> wrote:
> > > On Wed, Aug 11, 2021 at 11:05:55AM +0300, Andy Shevchenko wrote:
> > > > On Mon, Aug 09, 2021 at 03:28:40PM -0700, Dan Williams wrote:
> > > > > In preparation for CXL labels that move the uuid to a different offset
> > > > > in the label, add nsl_{ref,get,validate}_uuid(). These helpers use the
> > > > > proper uuid_t type. That type definition predated the libnvdimm
> > > > > subsystem, so now is as a good a time as any to convert all the uuid
> > > > > handling in the subsystem to uuid_t to match the helpers.
> > > > >
> > > > > As for the whitespace changes, all new code is clang-format compliant.
> > > >
> > > > Thanks, looks good to me!
> > > > Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > >
> > > Sorry, I'm in doubt this Rb stays. See below.

Andy, does this incremental diff restore your reviewed-by? The awkward
piece of this for me is that it introduces a handful of unnecessary
memory copies. See some of the new nsl_get_uuid() additions and the
extra copy in nsl_uuid_equal()

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 1cdfbadb7408..52de60b7adee 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -988,8 +988,8 @@ static int btt_arena_write_layout(struct arena_info *arena)
                return -ENOMEM;

        strncpy(super->signature, BTT_SIG, BTT_SIG_LEN);
-       uuid_copy(&super->uuid, nd_btt->uuid);
-       uuid_copy(&super->parent_uuid, parent_uuid);
+       export_uuid(super->uuid, nd_btt->uuid);
+       export_uuid(super->parent_uuid, parent_uuid);
        super->flags = cpu_to_le32(arena->flags);
        super->version_major = cpu_to_le16(arena->version_major);
        super->version_minor = cpu_to_le16(arena->version_minor);
diff --git a/drivers/nvdimm/btt.h b/drivers/nvdimm/btt.h
index fc3512d92ae5..0c76c0333f6e 100644
--- a/drivers/nvdimm/btt.h
+++ b/drivers/nvdimm/btt.h
@@ -94,8 +94,8 @@ struct log_group {

 struct btt_sb {
        u8 signature[BTT_SIG_LEN];
-       uuid_t uuid;
-       uuid_t parent_uuid;
+       u8 uuid[16];
+       u8 parent_uuid[16];
        __le32 flags;
        __le16 version_major;
        __le16 version_minor;
diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
index 5ad45e9e48c9..8b52e5144f08 100644
--- a/drivers/nvdimm/btt_devs.c
+++ b/drivers/nvdimm/btt_devs.c
@@ -244,14 +244,16 @@ struct device *nd_btt_create(struct nd_region *nd_region)
  */
 bool nd_btt_arena_is_valid(struct nd_btt *nd_btt, struct btt_sb *super)
 {
-       const uuid_t *parent_uuid = nd_dev_to_uuid(&nd_btt->ndns->dev);
+       const uuid_t *ns_uuid = nd_dev_to_uuid(&nd_btt->ndns->dev);
+       uuid_t parent_uuid;
        u64 checksum;

        if (memcmp(super->signature, BTT_SIG, BTT_SIG_LEN) != 0)
                return false;

-       if (!uuid_is_null(&super->parent_uuid))
-               if (!uuid_equal(&super->parent_uuid, parent_uuid))
+       import_uuid(&parent_uuid, super->parent_uuid);
+       if (!uuid_is_null(&parent_uuid))
+               if (!uuid_equal(&parent_uuid, ns_uuid))
                        return false;

        checksum = le64_to_cpu(super->checksum);
diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 99608e6aeaae..a799ccbc8c05 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -925,7 +925,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
                if (!label_ent->label)
                        continue;
                if (test_and_clear_bit(ND_LABEL_REAP, &label_ent->flags) ||
-                   uuid_equal(nspm->uuid, nsl_ref_uuid(ndd, label_ent->label)))
+                   nsl_uuid_equal(ndd, label_ent->label, nspm->uuid))
                        reap_victim(nd_mapping, label_ent);
        }

@@ -1087,7 +1087,7 @@ static int __blk_label_update(struct nd_region *nd_region,
                /* mark unused labels for garbage collection */
                for_each_clear_bit_le(slot, free, nslot) {
                        nd_label = to_label(ndd, slot);
-                       if (!nsl_validate_uuid(ndd, nd_label, nsblk->uuid))
+                       if (!nsl_uuid_equal(ndd, nd_label, nsblk->uuid))
                                continue;
                        res = to_resource(ndd, nd_label);
                        if (res && is_old_resource(res, old_res_list,
@@ -1204,7 +1204,7 @@ static int __blk_label_update(struct nd_region *nd_region,
                if (!nd_label)
                        continue;
                nlabel++;
-               if (!nsl_validate_uuid(ndd, nd_label, nsblk->uuid))
+               if (!nsl_uuid_equal(ndd, nd_label, nsblk->uuid))
                        continue;
                nlabel--;
                list_move(&label_ent->list, &list);
@@ -1234,7 +1234,7 @@ static int __blk_label_update(struct nd_region *nd_region,
        }
        for_each_clear_bit_le(slot, free, nslot) {
                nd_label = to_label(ndd, slot);
-               if (!nsl_validate_uuid(ndd, nd_label, nsblk->uuid))
+               if (!nsl_uuid_equal(ndd, nd_label, nsblk->uuid))
                        continue;
                res = to_resource(ndd, nd_label);
                res->flags &= ~DPA_RESOURCE_ADJUSTED;
@@ -1338,7 +1338,7 @@ static int del_labels(struct nd_mapping
*nd_mapping, uuid_t *uuid)
                if (!nd_label)
                        continue;
                active++;
-               if (!nsl_validate_uuid(ndd, nd_label, uuid))
+               if (!nsl_uuid_equal(ndd, nd_label, uuid))
                        continue;
                active--;
                slot = to_slot(ndd, nd_label);
diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
index e6e77691dbec..6e07771aa8f1 100644
--- a/drivers/nvdimm/label.h
+++ b/drivers/nvdimm/label.h
@@ -79,7 +79,7 @@ struct nd_namespace_index {
  * @unused: must be zero
  */
 struct nd_namespace_label {
-       uuid_t uuid;
+       u8 uuid[16];
        u8 name[NSLABEL_NAME_LEN];
        __le32 flags;
        __le16 nlabel;
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 20ea3ccd1f29..d4959981c7d4 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1231,10 +1231,12 @@ static int namespace_update_uuid(struct
nd_region *nd_region,
                list_for_each_entry(label_ent, &nd_mapping->labels, list) {
                        struct nd_namespace_label *nd_label = label_ent->label;
                        struct nd_label_id label_id;
+                       uuid_t uuid;

                        if (!nd_label)
                                continue;
-                       nd_label_gen_id(&label_id, nsl_ref_uuid(ndd, nd_label),
+                       nsl_get_uuid(ndd, nd_label, &uuid);
+                       nd_label_gen_id(&label_id, &uuid,
                                        nsl_get_flags(ndd, nd_label));
                        if (strcmp(old_label_id.id, label_id.id) == 0)
                                set_bit(ND_LABEL_REAP, &label_ent->flags);
@@ -1856,7 +1858,7 @@ static bool has_uuid_at_pos(struct nd_region
*nd_region, const uuid_t *uuid,
                        if (!nsl_validate_isetcookie(ndd, nd_label, cookie))
                                continue;

-                       if (!nsl_validate_uuid(ndd, nd_label, uuid))
+                       if (!nsl_uuid_equal(ndd, nd_label, uuid))
                                continue;

                        if (!nsl_validate_type_guid(ndd, nd_label,
@@ -1900,7 +1902,7 @@ static int select_pmem_id(struct nd_region
*nd_region, const uuid_t *pmem_id)
                        nd_label = label_ent->label;
                        if (!nd_label)
                                continue;
-                       if (nsl_validate_uuid(ndd, nd_label, pmem_id))
+                       if (nsl_uuid_equal(ndd, nd_label, pmem_id))
                                break;
                        nd_label = NULL;
                }
@@ -1924,7 +1926,7 @@ static int select_pmem_id(struct nd_region
*nd_region, const uuid_t *pmem_id)
                else {
                        dev_dbg(&nd_region->dev, "%s invalid label for %pUb\n",
                                dev_name(ndd->dev),
-                               nsl_ref_uuid(ndd, nd_label));
+                               nsl_uuid_raw(ndd, nd_label));
                        return -EINVAL;
                }

@@ -1954,6 +1956,7 @@ static struct device
*create_namespace_pmem(struct nd_region *nd_region,
        resource_size_t size = 0;
        struct resource *res;
        struct device *dev;
+       uuid_t uuid;
        int rc = 0;
        u16 i;

@@ -1964,12 +1967,12 @@ static struct device
*create_namespace_pmem(struct nd_region *nd_region,

        if (!nsl_validate_isetcookie(ndd, nd_label, cookie)) {
                dev_dbg(&nd_region->dev, "invalid cookie in label: %pUb\n",
-                       nsl_ref_uuid(ndd, nd_label));
+                       nsl_uuid_raw(ndd, nd_label));
                if (!nsl_validate_isetcookie(ndd, nd_label, altcookie))
                        return ERR_PTR(-EAGAIN);

                dev_dbg(&nd_region->dev, "valid altcookie in label: %pUb\n",
-                       nsl_ref_uuid(ndd, nd_label));
+                       nsl_uuid_raw(ndd, nd_label));
        }

        nspm = kzalloc(sizeof(*nspm), GFP_KERNEL);
@@ -1985,11 +1988,12 @@ static struct device
*create_namespace_pmem(struct nd_region *nd_region,
        res->flags = IORESOURCE_MEM;

        for (i = 0; i < nd_region->ndr_mappings; i++) {
-               if (has_uuid_at_pos(nd_region, nsl_ref_uuid(ndd, nd_label),
-                                   cookie, i))
+               uuid_t uuid;
+
+               nsl_get_uuid(ndd, nd_label, &uuid);
+               if (has_uuid_at_pos(nd_region, &uuid, cookie, i))
                        continue;
-               if (has_uuid_at_pos(nd_region, nsl_ref_uuid(ndd, nd_label),
-                                   altcookie, i))
+               if (has_uuid_at_pos(nd_region, &uuid, altcookie, i))
                        continue;
                break;
        }
@@ -2003,7 +2007,7 @@ static struct device
*create_namespace_pmem(struct nd_region *nd_region,
                 * find a dimm with two instances of the same uuid.
                 */
                dev_err(&nd_region->dev, "%s missing label for %pUb\n",
-                       nvdimm_name(nvdimm), nsl_ref_uuid(ndd, nd_label));
+                       nvdimm_name(nvdimm), nsl_uuid_raw(ndd, nd_label));
                rc = -EINVAL;
                goto err;
        }
@@ -2016,7 +2020,8 @@ static struct device
*create_namespace_pmem(struct nd_region *nd_region,
         * the dimm being enabled (i.e. nd_label_reserve_dpa()
         * succeeded).
         */
-       rc = select_pmem_id(nd_region, nsl_ref_uuid(ndd, nd_label));
+       nsl_get_uuid(ndd, nd_label, &uuid);
+       rc = select_pmem_id(nd_region, &uuid);
        if (rc)
                goto err;

@@ -2042,8 +2047,8 @@ static struct device
*create_namespace_pmem(struct nd_region *nd_region,
                WARN_ON(nspm->alt_name || nspm->uuid);
                nspm->alt_name = kmemdup(nsl_ref_name(ndd, label0),
                                         NSLABEL_NAME_LEN, GFP_KERNEL);
-               nspm->uuid = kmemdup(nsl_ref_uuid(ndd, label0), sizeof(uuid_t),
-                                    GFP_KERNEL);
+               nsl_get_uuid(ndd, label0, &uuid);
+               nspm->uuid = kmemdup(&uuid, sizeof(uuid_t), GFP_KERNEL);
                nspm->lbasize = nsl_get_lbasize(ndd, label0);
                nspm->nsio.common.claim_class =
                        nsl_get_claim_class(ndd, label0);
@@ -2228,7 +2233,7 @@ static int add_namespace_resource(struct
nd_region *nd_region,
                        continue;
                }

-               if (!nsl_validate_uuid(ndd, nd_label, uuid))
+               if (!nsl_uuid_equal(ndd, nd_label, uuid))
                        continue;
                if (is_namespace_blk(devs[i])) {
                        res = nsblk_add_resource(nd_region, ndd,
@@ -2260,6 +2265,7 @@ static struct device
*create_namespace_blk(struct nd_region *nd_region,
        char name[NSLABEL_NAME_LEN];
        struct device *dev = NULL;
        struct resource *res;
+       uuid_t uuid;

        if (!nsl_validate_type_guid(ndd, nd_label, &nd_set->type_guid))
                return ERR_PTR(-EAGAIN);
@@ -2274,7 +2280,8 @@ static struct device
*create_namespace_blk(struct nd_region *nd_region,
        dev->parent = &nd_region->dev;
        nsblk->id = -1;
        nsblk->lbasize = nsl_get_lbasize(ndd, nd_label);
-       nsblk->uuid = kmemdup(nsl_ref_uuid(ndd, nd_label),
sizeof(uuid_t), GFP_KERNEL);
+       nsl_get_uuid(ndd, nd_label, &uuid);
+       nsblk->uuid = kmemdup(&uuid, sizeof(uuid_t), GFP_KERNEL);
        nsblk->common.claim_class = nsl_get_claim_class(ndd, nd_label);
        if (!nsblk->uuid)
                goto blk_err;
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 132a8021e3ad..b781bf674f0a 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -180,7 +180,7 @@ static inline const uuid_t *nsl_get_uuid(struct
nvdimm_drvdata *ndd,
                                         struct nd_namespace_label *nd_label,
                                         uuid_t *uuid)
 {
-       uuid_copy(uuid, &nd_label->uuid);
+       import_uuid(uuid, nd_label->uuid);
        return uuid;
 }

@@ -188,21 +188,24 @@ static inline const uuid_t *nsl_set_uuid(struct
nvdimm_drvdata *ndd,
                                         struct nd_namespace_label *nd_label,
                                         const uuid_t *uuid)
 {
-       uuid_copy(&nd_label->uuid, uuid);
-       return &nd_label->uuid;
+       export_uuid(nd_label->uuid, uuid);
+       return uuid;
 }

-static inline bool nsl_validate_uuid(struct nvdimm_drvdata *ndd,
-                                    struct nd_namespace_label *nd_label,
-                                    const uuid_t *uuid)
+static inline bool nsl_uuid_equal(struct nvdimm_drvdata *ndd,
+                                 struct nd_namespace_label *nd_label,
+                                 const uuid_t *uuid)
 {
-       return uuid_equal(&nd_label->uuid, uuid);
+       uuid_t tmp;
+
+       import_uuid(&tmp, nd_label->uuid);
+       return uuid_equal(&tmp, uuid);
 }

-static inline const uuid_t *nsl_ref_uuid(struct nvdimm_drvdata *ndd,
-                                        struct nd_namespace_label *nd_label)
+static inline const u8 *nsl_uuid_raw(struct nvdimm_drvdata *ndd,
+                                    struct nd_namespace_label *nd_label)
 {
-       return &nd_label->uuid;
+       return nd_label->uuid;
 }

 bool nsl_validate_blk_isetcookie(struct nvdimm_drvdata *ndd,
