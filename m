Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8502A70
	for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 23:01:37 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id bo18so6181141pjb.0
        for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 16:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yxej9o+kAuH8mw1puVow9dkxnPzrO/KbVD0nxt+UR8c=;
        b=Ukp7AZo+GcRhDxWPQqjX4x5guiaIclboctwL6bL6a6Cx2sOB0t1HM5XskeGCQlfz4Z
         wyQGwJoSIVhS3jlm/78AQuWneWFhopVMyUHORlK7aBuAwtJdWo6Zng8Rat8sZ6sI9SVg
         gTUl4Tuw+bvL2+9CJPkHq0c5kWR4yNqkb/S74Kq1OMzrGdWMo/s//t5ZOVwKxyNQNtSh
         aAaVjhS6/iJg7puBFGgNRhRo9MA6xrgJZbVpAQqa7yom1gJrGvlIv8lop4tsFf62vXFH
         Gmh9xsBX2v0F7ELvTIy2Futzyv4ZVCvAvVvoq1pB1G8D/YTeqhCwYXF0+KTFNvq86ZfT
         QKVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yxej9o+kAuH8mw1puVow9dkxnPzrO/KbVD0nxt+UR8c=;
        b=pKQEjZCVM7X8J2sB48ci8WeiUUVgF52EljvNQlLSVV1VQ4El3LB9rsL36XBCn7aWkv
         D0QXqS8M3fytTgnCBXoGjEx4P8SQwT3QpQRbN8uVM7kkbv9wkPCc5dhWGrdXpcF62xqq
         Gy49SIXVYPeXkQ4z/XPbUAI+xrdd5hP93XnngKzFgZgWvQ0PNwVGNNs7knbQE8k/5GeT
         h++KjVjO3z7EKpo5SzaK76dHOAAbfC+CxGSi1RSSx/qFfSQDuqaYE6C7WL7ai38qk5nu
         0kOhFLJclYBX2HR++xoVCQy4sc8bgG6TmPHruGniOKGfwBFgu1h3h8EwGdWeDUMBGECZ
         1rWA==
X-Gm-Message-State: AOAM533TvtP6U3d4owKkrrVU4KvMxr+9/rATLPa73Qc6952szEVy2WhL
	OpZI96MA4yE3J3sphk1Jp2HPoDaEBRXsq64FJJNrQQ==
X-Google-Smtp-Source: ABdhPJy/n2WoVwFLflG267mv2Hg6lRUCGT0lEgyePr7ZBJGDuzEnRcQycD8RH97G0CIC33HpmyIjG/jZyAqYRKidV5Q=
X-Received: by 2002:a17:90b:23d6:: with SMTP id md22mr12577593pjb.149.1628722897133;
 Wed, 11 Aug 2021 16:01:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162854812641.1980150.4928659819619856243.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210811194130.00006076@Huawei.com>
In-Reply-To: <20210811194130.00006076@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Aug 2021 16:01:26 -0700
Message-ID: <CAPcyv4hD16UzKBDHDAbUwmTM01ycXcJCFmS8S11C4JmP1A8d6Q@mail.gmail.com>
Subject: Re: [PATCH 11/23] libnvdimm/labels: Introduce CXL labels
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Ben Widawsky <ben.widawsky@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, 
	"Schofield, Alison" <alison.schofield@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Aug 11, 2021 at 11:42 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Mon, 9 Aug 2021 15:28:46 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > Now that all of use sites of label data have been converted to nsl_*
> > helpers, introduce the CXL label format. The ->cxl flag in
> > nvdimm_drvdata indicates the label format the device expects. A
> > follow-on patch allows a bus provider to select the label style.
> >
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> A few trivial things inline. Nothing that actually 'needs' changing though.
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>
> > index e6e77691dbec..71ffde56fac0 100644
> > --- a/drivers/nvdimm/label.h
> > +++ b/drivers/nvdimm/label.h
> > @@ -64,40 +64,77 @@ struct nd_namespace_index {
> >       u8 free[];
> >  };
> >
> > -/**
> > - * struct nd_namespace_label - namespace superblock
> > - * @uuid: UUID per RFC 4122
> > - * @name: optional name (NULL-terminated)
> > - * @flags: see NSLABEL_FLAG_*
> > - * @nlabel: num labels to describe this ns
> > - * @position: labels position in set
> > - * @isetcookie: interleave set cookie
> > - * @lbasize: LBA size in bytes or 0 for pmem
> > - * @dpa: DPA of NVM range on this DIMM
> > - * @rawsize: size of namespace
> > - * @slot: slot of this label in label area
> > - * @unused: must be zero
> > - */
> >  struct nd_namespace_label {
> > +     union {
> Cross reference might be a nice thing to include?
> Table 212 I think...
> > +             struct nvdimm_cxl_label {
> > +                     uuid_t type;
> > +                     uuid_t uuid;
> > +                     u8 name[NSLABEL_NAME_LEN];
> > +                     __le32 flags;
> > +                     __le16 nlabel;
>
> Perhaps call out nlabel is nrange in the spec?

Actually, this is a bug, because nlabel in EFI labels is the width of
the interleave set. In CXL labels that property is moved to the region
and this field is only for discontiguous namespace support. Good
indirect catch!

>
> > +                     __le16 position;
> > +                     __le64 dpa;
> > +                     __le64 rawsize;
> > +                     __le32 slot;
> > +                     __le32 align;
> > +                     uuid_t region_uuid;
> > +                     uuid_t abstraction_uuid;
> > +                     __le16 lbasize;
> > +                     u8 reserved[0x56];
> > +                     __le64 checksum;
> > +             } cxl;
> > +             /**
> > +              * struct nvdimm_efi_label - namespace superblock
> > +              * @uuid: UUID per RFC 4122
> > +              * @name: optional name (NULL-terminated)
> > +              * @flags: see NSLABEL_FLAG_*
> > +              * @nlabel: num labels to describe this ns
> > +              * @position: labels position in set
> > +              * @isetcookie: interleave set cookie
> > +              * @lbasize: LBA size in bytes or 0 for pmem
> > +              * @dpa: DPA of NVM range on this DIMM
> > +              * @rawsize: size of namespace
> > +              * @slot: slot of this label in label area
> > +              * @unused: must be zero
> > +              */
> > +             struct nvdimm_efi_label {
> > +                     uuid_t uuid;
> > +                     u8 name[NSLABEL_NAME_LEN];
> > +                     __le32 flags;
> > +                     __le16 nlabel;
> > +                     __le16 position;
> > +                     __le64 isetcookie;
> > +                     __le64 lbasize;
> > +                     __le64 dpa;
> > +                     __le64 rawsize;
> > +                     __le32 slot;
> > +                     /*
> > +                      * Accessing fields past this point should be
> > +                      * gated by a efi_namespace_label_has() check.
> > +                      */
> > +                     u8 align;
> > +                     u8 reserved[3];
> > +                     guid_t type_guid;
> > +                     guid_t abstraction_guid;
> > +                     u8 reserved2[88];
> > +                     __le64 checksum;
> > +             } efi;
> > +     };
> > +};
> > +
> > +struct cxl_region_label {
>
> Perhaps separate this out to another patch so the diff ends up less confusing?

I'll take a look.
