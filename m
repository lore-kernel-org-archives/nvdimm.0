Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DA172
	for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 22:44:51 +0000 (UTC)
Received: by mail-pg1-f175.google.com with SMTP id r2so7645698pgl.10
        for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 15:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7vT9LtqjM4hUEvopvVGqYSC2xSzmWUEs3Sms8s1BSqM=;
        b=6FZqFPBw+R5AYqv8ywZrJdSiPkUj54fMsGJjcIr790iml/yDsuzDX1YzXlfcKmaF7G
         NKmhuCzjwzvlW0a4wC8/R3XjnoozRFDjSw6c7kQmWOiK2xRkNAonvDPE1XS7SfZ3hPbf
         M4P3hCNqfN/s0fYSsxSXGga7efMX01/r8c4zjdUUnUDLx7dBpDdbwbBvakLMtXYRKKGd
         FLmVSt3udwIC/fO2lNWwPf3hyqdYvaE3fPcrMbaVQJEneMe/1YGTLGJc8JhZbNvbQV3g
         FqZ/VmPdQB6X+A4CgNa/7eaZWWvc5/CY5k3aG+Nia5zqcYpkHve3ZkZzt/pZXoVXwcmw
         FmtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7vT9LtqjM4hUEvopvVGqYSC2xSzmWUEs3Sms8s1BSqM=;
        b=EoPe+1SGr42dNYhxEIj/K+MYP20SCNOyYl2/HY7R0c8SCiCTnJOoBy2GmDYwFL9LNh
         QWHb5/RsWbdpdJg2Tr28QDuaD1CDxVO9beWgOBUynm0Yi+HH276/Fcuh7z0gIRNdT1Xe
         rbJD6dsbp7JJh0oKombtLJnFWmFY/GoXD7PiT2gBUfAL2ZzBFuPicQ25+00Cr14Hm8I5
         LYAC3H2J/HsV4pGFr8xCKOsqee8nbwPbrFn2nyQpIiIncVOpODKbCHIUyGMYFsBqSXyg
         1utcEbFChQNRzwB2SWxF55GXsaCr4wfWEsMPCF+ug/8sAns6MtShqfAikX8PGPnb4dck
         qC7g==
X-Gm-Message-State: AOAM532PTYJlvlNQns8j6lrsS+E95U6ATB7Q6CYR8n4xtkY0a3HPWu1j
	31i0R5dND0RfOc0bPjypUr+MSf8AamybfUtoSFyV+Q==
X-Google-Smtp-Source: ABdhPJzy31haSgOiwTjsmjJKnIscB5O2l3hC1zUJrgJvxYG9sYuji48u3sv2ZLOVx5Ckxy/huGWzSqj0Qzl4dstf0Ew=
X-Received: by 2002:a63:1e0e:: with SMTP id e14mr6937318pge.5.1633041890537;
 Thu, 30 Sep 2021 15:44:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <YVYQPtQrlKFCXPyd@zn.tnic> <33502a16719f42aa9664c569de4533df@intel.com>
 <YVYXjoP0n1VTzCV7@zn.tnic> <2c4ccae722024a2fbfb9af4f877f4cbf@intel.com>
 <YVYe9xrXiwF3IqB2@zn.tnic> <CAPcyv4iHmcYV6Dc35Rfp_k9oMsr9qWEdALFs70-bNOvZK00f9A@mail.gmail.com>
 <YVYj8PpzIIo1qu1U@zn.tnic> <CAPcyv4jEby_ifqgPyfbSgouLJKseNRCCN=rcLHze_Y4X8BZC7g@mail.gmail.com>
 <YVYqJZhBiTMXezZJ@zn.tnic> <CAPcyv4heNPRqA-2SMsMVc4w7xGo=xgu05yD2nsVbCwGELa-0hQ@mail.gmail.com>
 <YVY7wY/mhMiRLATk@zn.tnic>
In-Reply-To: <YVY7wY/mhMiRLATk@zn.tnic>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 30 Sep 2021 15:44:40 -0700
Message-ID: <CAPcyv4jV_8JCNSXg9W3ZNDhZEd=z2QyLWPgLUiVN92rp7zWReA@mail.gmail.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
To: Borislav Petkov <bp@alien8.de>
Cc: "Luck, Tony" <tony.luck@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Jane Chu <jane.chu@oracle.com>, Luis Chamberlain <mcgrof@suse.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 30, 2021 at 3:36 PM Borislav Petkov <bp@alien8.de> wrote:
>
> On Thu, Sep 30, 2021 at 02:41:52PM -0700, Dan Williams wrote:
> > I fail to see the point of that extra plumbing when MSi_MISC
> > indicating "whole_page", or not is sufficient. What am I missing?
>
> I think you're looking at it from the wrong side... (or it is too late
> here, but we'll see). Forget how a memory type can be mapped but think
> about how the recovery action looks like.
>
> - DRAM: when a DRAM page is poisoned, it is only poisoned as a whole
> page by memory_failure(). whole_page is always true here, no matter what
> the hardware says because we don't and cannot do any sub-page recovery
> actions. So it doesn't matter how we map it, UC, NP... I suggested NP
> because the page is practically not present if you want to access it
> because mm won't allow it...
>
> - PMEM: reportedly, we can do sub-page recovery here so PMEM should be
> mapped in the way it is better for the recovery action to work.
>
> In both cases, the recovery action should control how the memory type is
> mapped.
>
> Now, you say we cannot know the memory type when the error gets
> reported.
>
> And I say: for simplicity's sake, we simply go and work with whole
> pages. Always. That is the case anyway for DRAM.
>
> For PMEM, AFAIU, it doesn't matter whether it is a whole page or not -
> the PMEM driver knows how to do those sub-pages accesses.
>
> IOW, set_mce_nospec() should simply do:
>
>         rc = set_memory_np(decoy_addr, 1);
>
> and that's it.

The driver uses the direct-map to do the access. It uses the
direct-map because it has also arranged for pfn_to_page() to work for
PMEM pages. So if PMEM is in the direct-map is marked NP then the
sub-page accesses will fault.

Now, the driver could set up and tear down page tables for the pfn
whenever it is asked to do I/O over a potentially poisoned pfn. Is
that what you are suggesting? It seems like a significant amount of
overhead, but it would at least kick this question out of the purview
of the MCE code.
