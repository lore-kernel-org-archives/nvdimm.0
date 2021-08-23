Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06EF53FC2
	for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 20:56:30 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id mq3so12765848pjb.5
        for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 13:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vc/aN0oRmNAXm6mXAGLkDsuBBboDWXtU8orOhuBIg2Q=;
        b=B1PN8/oQCmXbi6l3QVCMPVcI3O4p3WLJA2eJeCS8TyZ/9O3zP1YyDhITU4ZcQUMu9A
         8Jv3FvTsSNw0wedo++tDncepWpg5fNlx5yOWydCxJxO2LvZgmafOowgtsiW33KkmxXri
         JicnY3m49d7Mh7sxoVHfKYR9tR4vxLm0cTOPiz13j1eLGWJpH4EqBXIsByJu+wugislF
         s6cQkVjauCeFLAIH7yrSgJ+rNWkZxDUHqX64XCMW3WAknCaEAVdKpKS94amQp5lRvzVE
         JLGKD1TjCujv8RstgFNxXr4d9/bplk1r3u+5Pw+HrYG4JEKzIAam/KjQAVW3vquIOGjY
         zzmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vc/aN0oRmNAXm6mXAGLkDsuBBboDWXtU8orOhuBIg2Q=;
        b=U9drt4xaReLKYs4d+dMQFIGW6KapFx8lnywfrSyOVOaFcbyibMOhEkj9JVDVB9zJsI
         zdTtzOtEH1DpeUhOTOL77/HGClvAyBDeY1njw8qkUcvosNYNllcsNS23FRRnGKdBSQTW
         rhsLsPhPjcy7IAIKC+SYnZqAtM+QawcHZvT4LVH38xmbsYj6q5VqF89gPqRXs2Aalrhg
         YNQEkGnSEaMt6u8oaavMZTiAWtZkbj1WOv7KO52M3mn6IPgfWs9rW8GRd4ze1icWud0x
         K+1ujEdbz/07RBEjn2UESoFP0bx93yaXVy5VvNiOW0rvApqlrWA6wg5vAElJGjQSyu/v
         U57A==
X-Gm-Message-State: AOAM530nE4Ha62deW6V6rCBuIZ1Gk4Bb7/JOPLSB+S85dtzama+Y/vjC
	WNNKx9+T+05XaaQ5Gk9b97UyCobwtigeRV5/tHMDuA==
X-Google-Smtp-Source: ABdhPJzahdnrNond377llVfK4n8/pb9BvsPDfdsBxiv7TsIPXVvYqFPJnZxVBQsD+DCyRAqPYzTF7GnMCMP9/MlvOFQ=
X-Received: by 2002:a17:902:edd0:b0:135:b351:bd5a with SMTP id
 q16-20020a170902edd000b00135b351bd5amr2063016plk.52.1629752190557; Mon, 23
 Aug 2021 13:56:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210823123516.969486-1-hch@lst.de> <20210823123516.969486-5-hch@lst.de>
In-Reply-To: <20210823123516.969486-5-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 23 Aug 2021 13:56:19 -0700
Message-ID: <CAPcyv4j2-8OPHDowaH0ogZP5qKM6rkGVgjjPPRt1k2DC_SpnFw@mail.gmail.com>
Subject: Re: [PATCH 4/9] dax: mark dax_get_by_host static
To: Christoph Hellwig <hch@lst.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	linux-xfs <linux-xfs@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Aug 23, 2021 at 5:39 AM Christoph Hellwig <hch@lst.de> wrote:
>
> And move the code around a bit to avoid a forward declaration.

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
