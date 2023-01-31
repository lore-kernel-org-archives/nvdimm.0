Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711FF8C04
	for <nvdimm@lists.linux.dev>; Tue, 31 Jan 2023 15:16:14 +0000 (UTC)
Received: by mail-vs1-f42.google.com with SMTP id y8so16424352vsq.0
        for <nvdimm@lists.linux.dev>; Tue, 31 Jan 2023 07:16:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hqSkLxxkS4WxXckkEqwqJ2FoqZVZdDRCF2SZ/0LGP88=;
        b=JtZQ/lBmt1byjRUtXNuodezmFLI68Y4U1n9cV4QC89Jrp7zRN+opOXcshCLau26tiK
         Nd7XZH0XhmPh/ylPrymz6yitRCTAk77brQH6Y7T9Rwe3+PBn1kmbTPPEa5n39WSpbPC/
         3UVWX2vsjw2pYxx03h0V6D3FqfEWNxMiI4V+1HfBhQ7IPqlBbu3/6JtPVaSx9TOUQRxf
         2mhIwkexBZz2BsG43yqbCb10cc/be7/cOMguEs3i6vHqPgytYuZugK70wSwuExWwjz2Y
         zsQhqw+EG63ShEJ2r0cpRtXL/S2Fd3ulNRqK5Gi2R4vnSEqOzBBhRqgx2w0+r7or3E81
         nYJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hqSkLxxkS4WxXckkEqwqJ2FoqZVZdDRCF2SZ/0LGP88=;
        b=l8MMcTkisOPtLVy9doCMekegcXyh5z8EJh+hd2CJbbU8YbJiIbSfMVFBuDlrzMbS5C
         OJqPbIINERl/b5qbVzaOdEVhpTTAaJVeYzh+o3SO5M7jUpaEIhn1gMN2x2w1XN39VJur
         qGZJf3+f1DnSVETOR06JXtk6r71bQxLZseiNjZBRW2HIrcy2cS2ZUpIgXuL8u/EIA45W
         ZKDvigzXcP4AMGjdGfEYB/qdG/nmndCpRCtnN8eLP/6m0j8MRb7zWyp7uCAfMYvqRGaf
         nZd3UEhsxLwT3LR+QaXyxVGMLj7u3Zw1NPuL5jnFfel0TjeN2fQBV4i3kG9mufrTq94I
         8ywg==
X-Gm-Message-State: AO0yUKWNHRfjihJSTgyk81XPIRVlZBecYDeY1/bKNlasgtyYcbt8p/ID
	Vqj1JnaX3uquZyK00I0i+LCfToklc4+2N3151XnO1Q==
X-Google-Smtp-Source: AK7set9TuI801MQUIobSqj1yTStH7qsNvDVpmcS4/LrfPrPNvx2T47lNeSF2Vu2NdDktr05dS0mA/2X+cH7Q7NH14kc=
X-Received: by 2002:a67:c31e:0:b0:3ed:1e92:a87f with SMTP id
 r30-20020a67c31e000000b003ed1e92a87fmr2427528vsj.1.1675178173210; Tue, 31 Jan
 2023 07:16:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <167467815773.463042.7022545814443036382.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <167467815773.463042.7022545814443036382.stgit@dwillia2-xfh.jf.intel.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 31 Jan 2023 16:15:36 +0100
Message-ID: <CAG_fn=U37EVEYYBTRWvOzVq7n0sSqaS5UN-9pjfZQnczAv3B4w@mail.gmail.com>
Subject: Re: [PATCH v2] nvdimm: Support sizeof(struct page) > MAX_STRUCT_PAGE_SIZE
To: Dan Williams <dan.j.williams@intel.com>
Cc: nvdimm@lists.linux.dev, stable@vger.kernel.org, 
	Marco Elver <elver@google.com>, Jeff Moyer <jmoyer@redhat.com>, linux-mm@kvack.org, 
	kasan-dev@googlegroups.com, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Jan 25, 2023 at 9:23 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> Commit 6e9f05dc66f9 ("libnvdimm/pfn_dev: increase MAX_STRUCT_PAGE_SIZE")
>
> ...updated MAX_STRUCT_PAGE_SIZE to account for sizeof(struct page)
> potentially doubling in the case of CONFIG_KMSAN=y. Unfortunately this
> doubles the amount of capacity stolen from user addressable capacity for
> everyone, regardless of whether they are using the debug option. Revert
> that change, mandate that MAX_STRUCT_PAGE_SIZE never exceed 64, but
> allow for debug scenarios to proceed with creating debug sized page maps
> with a compile option to support debug scenarios.
>
> Note that this only applies to cases where the page map is permanent,
> i.e. stored in a reservation of the pmem itself ("--map=dev" in "ndctl
> create-namespace" terms). For the "--map=mem" case, since the allocation
> is ephemeral for the lifespan of the namespace, there are no explicit
> restriction. However, the implicit restriction, of having enough
> available "System RAM" to store the page map for the typically large
> pmem, still applies.
>
> Fixes: 6e9f05dc66f9 ("libnvdimm/pfn_dev: increase MAX_STRUCT_PAGE_SIZE")
> Cc: <stable@vger.kernel.org>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Marco Elver <elver@google.com>
> Reported-by: Jeff Moyer <jmoyer@redhat.com>
Acked-by: Alexander Potapenko <glider@google.com>
