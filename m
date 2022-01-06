Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384A4168
	for <nvdimm@lists.linux.dev>; Thu,  6 Jan 2022 22:47:09 +0000 (UTC)
Received: by mail-pg1-f174.google.com with SMTP id i8so3826294pgt.13
        for <nvdimm@lists.linux.dev>; Thu, 06 Jan 2022 14:47:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fSkscOE9BOBdVvhl5fpqHN/yc+QiTcotsBgdCKW/ymw=;
        b=ySVJVexW5ljY+ds3EEbv5zTTrzy4rP02JBQegyP2ndXwAukEOTaOLfK5ZZznt+g7eU
         2k/v5p6AcwtsOZ/jVynIgTeO7Ek1SxtoM4hFT5DUYiOXtQCCQkxu9Fz1hy539TH+Wf5B
         LbXMnMRZqhZWE5+8HARIaSlBfViV2KAlnsqI+ezltRFkYitu47VRGbIahfH0sX1vZUTx
         vqwJIXT6WpMQS/pTupodr7+FsbhvXI8g089vWkjq+USvInx+aD926H9nzY56+ccT/aAm
         w+DkvZTsJSEC5eZp8+wRZL++dxiQn82Qy7TO24+XYcqtRodztROsEGLNGHYcbQatbI/b
         kvlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fSkscOE9BOBdVvhl5fpqHN/yc+QiTcotsBgdCKW/ymw=;
        b=K/gctBsKHxo5LDYcGV65NFDPoDKMiyFXRHob7cJXFd9Nf2m7HZ50yzyrPAr7IZwZgN
         7CcHnXUGu968U2y20dEbviXPp/XXwXBUkOxZqigOB6d1akmHLL/I1E9YfU8xI/R1vIhs
         S6KXaEfTiiKhAwsv3eQMLEmtoKZgqoD4wXzyKxn1jBsgj4fUWEMSlTfVF96/anO0hXOh
         slCN+SZbRw+bOSG0VCOLjnEsCKGAVaPdqsypLZIVxcbFzcr1T1yUh5zgKQImARd/c1pE
         JiXHeYiFJPeEC6H9jJcam5JGtHKrYudE9qW7NNdzf12jVvlbyLib6Do5IQOfRppQ5zID
         rkTQ==
X-Gm-Message-State: AOAM530Pn84lnuXvBtXOVY83vpshKXj2LPeEtdTgMRryrAT5VWqgGQZ/
	3uU/Irtth96+bdbRjZle0WaCknHgShS2Hb/R/lzD1w==
X-Google-Smtp-Source: ABdhPJzFLhyZDBU+kmeOdNF6km1lPjt2gxScbzWbpyi3YjO6Ym6xfOYH4FrW8FieZP8/ysUIT/Atj5Kj5jHl0NI3pKk=
X-Received: by 2002:a63:710f:: with SMTP id m15mr23159410pgc.40.1641509228660;
 Thu, 06 Jan 2022 14:47:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220106050940.743232-1-vishal.l.verma@intel.com> <20220106050940.743232-3-vishal.l.verma@intel.com>
In-Reply-To: <20220106050940.743232-3-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 6 Jan 2022 14:46:57 -0800
Message-ID: <CAPcyv4gCLPYPixMydOfW_E77Qz+jZS1q8K8Vo2euXmC4oAL_Lw@mail.gmail.com>
Subject: Re: [ndctl PATCH 2/3] scripts: move 'prepare-release.sh' and
 'do_abidiff' into scripts/
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jan 5, 2022 at 9:10 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> The scripts directory in the ndctl tree is designated as the place for
> useful developer scripts that don't need to get packaged or distributed.
> Move the above out of contrib/ which does contain files that get
> packaged.
>

LGTM

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
