Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D903FCD
	for <nvdimm@lists.linux.dev>; Fri,  3 Sep 2021 21:09:59 +0000 (UTC)
Received: by mail-pg1-f172.google.com with SMTP id w8so296127pgf.5
        for <nvdimm@lists.linux.dev>; Fri, 03 Sep 2021 14:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w9zhRLHvyC6GtYT9kRzwbsDJaDIA3L/fwrcrNApvSww=;
        b=DhYmhEsgDyrlCbagHZp9RTzBIIqkHZgleBBZD8wDlOj6kzd/Y2OhTtZYf6Inn5HeFD
         PXL86A+FG5fLIqb7kK2Pl9JsmCbGvHGE1NW00RtMYLji2RHu9Mr6A96+of7zBZk13uiX
         0zIZEPkoJl1zWbBeggU9JbbQSlLJGMy58SndIt4ug5KySfQuiBp1MGlT7QvJL87kg8DL
         lcM9v5c4uIVF/2/nBsp5QvUO75u6Wi8PhyhnVQcHNpzyJLEDrSMEXOrFv3sSTu9cwcU2
         kX1cw6UIydEKzrrB0BilQnKtPV4Wk86/Bhtgpal0CoEniktAq+q2cgBNiTl+4gw+ziO/
         l7IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w9zhRLHvyC6GtYT9kRzwbsDJaDIA3L/fwrcrNApvSww=;
        b=B+ljtGh1eA+HNuwG7FAfzvg4CCOS7f7itWOlnx5r4D+ie5d+j9c+NBy+1MZ6sxkGh6
         dCF/MDrc6c4dexsSxVzpTr34Kx5eJ+yZb3TbfwxY/rh1zvHHktR0w8XWQ9+InHRuDoxq
         As+dNvj5m34C495GSTOpGdYUGVgw8EBZF5QbdmpMDdwiCpo3M7Xbzrh3dED+zp/zilxz
         iAUerIs7BF01HWA/V8CFy2KWWjni8nzplNbsDxFvd74Y1t0sfhA1yyt0o8iu4P5V01YG
         1CovOoX/AiOg8knlTG+0toyQz2w6zmvwl4rVaOt5UlMpBVH7iPBG6hUhQSRMlPKEgyjY
         Isxw==
X-Gm-Message-State: AOAM531oxsbQvAUq0WLqUA7eCp3YIuXrmMxXheUCM2ZTohcFOqmVFskO
	5ZGC9KWw2peE3H4tTHcJBLDlk60+SnpNUIwlT5SJPw==
X-Google-Smtp-Source: ABdhPJyDXtyYzuS1JOu6AcYN+RB8LxGBHSzwi/F/N8dbtt+LixjocKttgDD91Q+goKN4YFauocg9ZrfwOa3SBbyUadY=
X-Received: by 2002:a63:3545:: with SMTP id c66mr815057pga.377.1630703399236;
 Fri, 03 Sep 2021 14:09:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162982123813.1124374.3721946437291753388.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210902192227.00006dc8@Huawei.com>
In-Reply-To: <20210902192227.00006dc8@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 3 Sep 2021 14:09:48 -0700
Message-ID: <CAPcyv4hq0BgeZc==w+ypC=RJscccf1JQB2Ynb0LkRYE1qr-gCg@mail.gmail.com>
Subject: Re: [PATCH v3 21/28] cxl/pmem: Translate NVDIMM label commands to CXL
 label commands
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, "Schofield, Alison" <alison.schofield@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, "Weiny, Ira" <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 2, 2021 at 11:22 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Tue, 24 Aug 2021 09:07:18 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > The LIBNVDIMM IOCTL UAPI calls back to the nvdimm-bus-provider to
> > translate the Linux command payload to the device native command format.
> > The LIBNVDIMM commands get-config-size, get-config-data, and
> > set-config-data, map to the CXL memory device commands device-identify,
> > get-lsa, and set-lsa. Recall that the label-storage-area (LSA) on an
> > NVDIMM device arranges for the provisioning of namespaces. Additionally
> > for CXL the LSA is used for provisioning regions as well.
> >
> > The data from device-identify is already cached in the 'struct cxl_mem'
> > instance associated with @cxl_nvd, so that payload return is simply
> > crafted and no CXL command is issued. The conversion for get-lsa is
> > straightforward, but the conversion for set-lsa requires an allocation
> > to append the set-lsa header in front of the payload.
> >
> > Acked-by: Ben Widawsky <ben.widawsky@intel.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Minor query inline.
>
[..]
> > +static int cxl_pmem_set_config_data(struct cxl_mem *cxlm,
> > +                                 struct nd_cmd_set_config_hdr *cmd,
> > +                                 unsigned int buf_len, int *cmd_rc)
> > +{
> > +     struct cxl_mbox_set_lsa {
> > +             u32 offset;
> > +             u32 reserved;
> > +             u8 data[];
> > +     } *set_lsa;
> > +     int rc;
> > +
> > +     if (sizeof(*cmd) > buf_len)
> > +             return -EINVAL;
> > +
> > +     /* 4-byte status follows the input data in the payload */
> > +     if (struct_size(cmd, in_buf, cmd->in_length) + 4 > buf_len)
> > +             return -EINVAL;
> > +
> > +     set_lsa =
> > +             kvzalloc(struct_size(set_lsa, data, cmd->in_length), GFP_KERNEL);
> > +     if (!set_lsa)
> > +             return -ENOMEM;
> > +
> > +     *set_lsa = (struct cxl_mbox_set_lsa) {
> > +             .offset = cmd->in_offset,
> > +     };
> > +     memcpy(set_lsa->data, cmd->in_buf, cmd->in_length);
> > +
> > +     rc = cxl_mem_mbox_send_cmd(cxlm, CXL_MBOX_OP_SET_LSA, set_lsa,
> > +                                struct_size(set_lsa, data, cmd->in_length),
> > +                                NULL, 0);
> > +
> > +     /* set "firmware" status */
> > +     *(u32 *) &cmd->in_buf[cmd->in_length] = 0;
>
> Are we guaranteed this is aligned? Not 'locally' obvious so maybe a comment?

Good point, let's just go ahead and use a put_unaligned() accessor.
