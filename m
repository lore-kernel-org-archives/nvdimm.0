Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3290C72
	for <nvdimm@lists.linux.dev>; Fri, 14 May 2021 00:58:47 +0000 (UTC)
Received: by mail-ed1-f44.google.com with SMTP id f1so10701295edt.4
        for <nvdimm@lists.linux.dev>; Thu, 13 May 2021 17:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qEpqh0+EO79bqyW92GQVGh/KezzVRI3iqRzND7tXdzE=;
        b=VyF5KAItiyhVUDoQPuSpn+6qkikMk2hl7TC6nDAY80mlI9Pwy7//OIK5bwd8VWGAjs
         LUoreoxokhhvpsC25SgrDuwwdLCMzPghiNv3kOqWghcYl5s19lLz86umn84/uvFpCKn7
         n6j5Kjexq6ICXKWPVLPeY+Z0gp6cI4cx1JQy0lAmT8rvNRbRqn48xIqLSlwSGZTVWCQq
         rxE36ApIMC0sHpYnPcGGFDjlGk/HSZSYK5zf2Hf04Up+ZKs4cUiUAMxCnVpvmwmOSZy9
         U8aW8T72WmOxPlXTzQGozkxhMI8VANb8asaEs4wrZHB2dNGDeoSdVls4rCw/oBbn3Pb7
         k5Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qEpqh0+EO79bqyW92GQVGh/KezzVRI3iqRzND7tXdzE=;
        b=dyNbh8vhwSAajRVZhFWyDf6LulKRUEAbH6z+xgwDuDZXk/XLE5df5jkPeGB63CQWI0
         kLGzoFIZ2FXV7R1LrgTF1DVNKAKkay9dk2QAiXO8HCRcIZpXcsI8VyQiqbaZbphUW5Sf
         f/Q+YQC2usN7TuOwfr3VNkBj2N0XH+YkYe+c51eSV6D7m74lHoBDridYqQWzi/GrGWsW
         7Ti86bY9peFt9iUPxzmtEN1kwMcfIwH3bP6w1PI4jATnfMWSpW86Wrvkn46n09aMoTsg
         Hr7Cg3hCvkffb7v1THKtZSqNc7DnGK1KP0EbNV/XL6cWqMkqQ85TyBkCuceG87w8N1Gv
         Jveg==
X-Gm-Message-State: AOAM530qT4+Bosl0mQZgTxbDJGovJ3Zqqj3iMzTx1y1Nj0myV7zWoLeY
	HxCEtrzZRi3T/DLdkBvk9T1/UlaQ+f220jD59gFVQQ==
X-Google-Smtp-Source: ABdhPJzh0giSiEG3dqURONhskurpZE+LPObxwoKMA9HM9nAfG4jEWbjEzfSMDxLImnc7mtMejPt2UnMYiX/bADUi9Qs=
X-Received: by 2002:a05:6402:54e:: with SMTP id i14mr54897192edx.210.1620953925739;
 Thu, 13 May 2021 17:58:45 -0700 (PDT)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <161898872871.3406469.4054282559340528393.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <161898872871.3406469.4054282559340528393.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 13 May 2021 17:58:37 -0700
Message-ID: <CAPcyv4jgkAze76c6TNJ1_OKM91xjH0c_UHpsYsvaLcw6-APGrA@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Move nvdimm mailing list
To: linux-nvdimm <linux-nvdimm@lists.01.org>
Cc: Ira Weiny <ira.weiny@intel.com>, "Oliver O'Halloran" <oohall@gmail.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
	Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Apr 21, 2021 at 12:05 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> After seeing some users have subscription management trouble, more spam
> than other Linux development lists, and considering some of the benefits
> of kernel.org hosted lists, nvdimm and persistent memory development is
> moving to nvdimm@lists.linux.dev.
>
> The old list will remain up until v5.14-rc1 and shutdown thereafter.
>

Events have transpired that require this schedule be expedited. So
once this patch ships in v5.13-rc2 the linux-nvdimm@lists.01.org list
will be shutdown and all future nvdimm correspondence must be sent to
nvdimm@lists.linux.dev.
