Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDA71FB4
	for <nvdimm@lists.linux.dev>; Mon, 11 Apr 2022 23:56:08 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id v12so2270925plv.4
        for <nvdimm@lists.linux.dev>; Mon, 11 Apr 2022 16:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u4J7Bf/GotxjJfY4hYTghw/TTioM2LYvPTAkJWjY17E=;
        b=HQ+2vciUuGFcRUAADBBBewhLLxx/n8IwutVwi9bDSH5UBx/sMIz11gFenVTKEO5i2V
         Z3KkkM9CsYrzCcapeOzqAPFCFARrC/nGi7vHH0YUZMEyTwShG2fVEKyBuJ+b4TCzPDd6
         szbu08LY1PXwGtFdjtHzkI48ZOaN1iB6bh793hvWxqcO0deFyRSoPQt9LUnPAXwTeeVl
         Tb/JasLYg9PNiFlSaZ65haBXwam6yS94qYrcv5vEzr4MKjqx1+yFqkfPGe4cwK/rfrsj
         +9U3IHhasFilk7p3D90KspNTXQykty6L7GEhgqlF9JxHABSU3bCtlbzBEt8Xnh/InXLg
         0JMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u4J7Bf/GotxjJfY4hYTghw/TTioM2LYvPTAkJWjY17E=;
        b=Y7ijc+SPT97VaUeGE2W0S4fKRkVwjFTnDYmmYU+X1GSr5Y0aQZ9VQdXSzeAsnIV+kb
         I4KWgPTEB60B4iru6YbgvIidk5hMiQYBCSOX2n3XumWE7uATud7+2M0pHAAEMyjEb2v/
         tlDc/HE/DJBW67ll+QpRDbb26/u/dN8qYwMrjaQnaPF70RJcW27gIJTFZ3+KofR5+9lm
         +uf2YaNkzo+3/k75kRtkYce3S2hrnc/1KEUys6EbYA8iI8io2p2M7GLE+IvX6cFxJj6M
         xEapqYY7v22R8W5NhmW45Dv1vwBp1x5a4YXKEo+JHIb1qK7tVQZldLAXH9IXJOmVwVVn
         hmww==
X-Gm-Message-State: AOAM531+/OkHZcmf1S0f7KsRCF5uyoLd69DZ82uI39LsrYzwO77/RnpL
	AmCpAPB8i/piZub67ewh4R8Q7JixnYs29qP6/uSCDw==
X-Google-Smtp-Source: ABdhPJwz526LJSdeFPj6/c7PsF49maypY+wjW8NyQ8pIICoB0k38/TF9Lk5dkB3kd2++yFgVX8lzKCKbNtcxf9v/5dw=
X-Received: by 2002:a17:902:7296:b0:14b:4bc6:e81 with SMTP id
 d22-20020a170902729600b0014b4bc60e81mr34383349pll.132.1649721368525; Mon, 11
 Apr 2022 16:56:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220405194747.2386619-1-jane.chu@oracle.com> <20220405194747.2386619-5-jane.chu@oracle.com>
 <Yk0i/pODntZ7lbDo@infradead.org> <196d51a3-b3cc-02ae-0d7d-ee6fbb4d50e4@oracle.com>
 <Yk52415cnFa39qil@infradead.org>
In-Reply-To: <Yk52415cnFa39qil@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 11 Apr 2022 16:55:58 -0700
Message-ID: <CAPcyv4gfF4AhxD_vqCS9CTRraj8GAMDYQ7Zb411+FvxhF4ccOw@mail.gmail.com>
Subject: Re: [PATCH v7 4/6] dax: add DAX_RECOVERY flag and .recovery_write dev_pgmap_ops
To: Christoph Hellwig <hch@infradead.org>
Cc: Jane Chu <jane.chu@oracle.com>, "david@fromorbit.com" <david@fromorbit.com>, 
	"djwong@kernel.org" <djwong@kernel.org>, "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>, 
	"dave.jiang@intel.com" <dave.jiang@intel.com>, "agk@redhat.com" <agk@redhat.com>, 
	"snitzer@redhat.com" <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, 
	"ira.weiny@intel.com" <ira.weiny@intel.com>, "willy@infradead.org" <willy@infradead.org>, 
	"vgoyal@redhat.com" <vgoyal@redhat.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Apr 6, 2022 at 10:31 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Apr 06, 2022 at 05:32:31PM +0000, Jane Chu wrote:
> > Yes, I believe Dan was motivated by avoiding the dm dance as a result of
> > adding .recovery_write to dax_operations.
> >
> > I understand your point about .recovery_write is device specific and
> > thus not something appropriate for device agnostic ops.
> >
> > I can see 2 options so far -
> >
> > 1)  add .recovery_write to dax_operations and do the dm dance to hunt
> > down to the base device that actually provides the recovery action
>
> That would be my preference.  But I'll wait for Dan to chime in.

Yeah, so the motivation was avoiding plumbing recovery through stacked
lookups when the recovery is specific to a pfn and the provider of
that pfn, but I also see it from Christoph's perspective that the only
agent that cares about recovery is the fsdax I/O path. Certainly
having ->dax_direct_access() take a DAX_RECOVERY flag and the op
itself go through the pgmap is a confusing split that I did not
anticipate when I made the suggestion. Since that flag must be there,
then the ->recovery_write() should also stay relative to a dax device.

Apologies for the thrash Jane.

One ask though, please separate plumbing the new flag argument to
->dax_direct_access() and plumbing the new operation into preparation
patches before filling them in with the new goodness.
