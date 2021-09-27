Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7293FCF
	for <nvdimm@lists.linux.dev>; Mon, 27 Sep 2021 18:19:35 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id w11so12324295plz.13
        for <nvdimm@lists.linux.dev>; Mon, 27 Sep 2021 11:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/zKrL812IZj983CDNoTAXGWrzyYsFXUo70xd8d5OVRw=;
        b=Jsb0eKvqCXj6YljT8mnNPPjr3BIta8VJgkFwUhes6b/1qGEctJiqdGoU7reuK1AZM/
         dRzwyM05Kp1f84uAdAfp6lpa6Kk6KrCctynYJjcNFlJqW67E/6X+ki37v3QUWU0m1/u9
         TcXQwmHrrC+9oANWkZnWvfG0vHePNl6ImGj+TPhUqDGEZvuThtKyx/QVWv+BDBO5CxEH
         nrnvSk8H17UdAOfIRs/v4MaCJiFlW6Utx65qH2WPjcTKzOWfyynuYxqSqy7z5IXJyz+K
         HWDDhB4TmrlY5XL9sfDfM16NI7TUx5PNG6Ocitq0UJCYq9SmfPkhVoCkM5WUHXeUawcz
         7uLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/zKrL812IZj983CDNoTAXGWrzyYsFXUo70xd8d5OVRw=;
        b=qlpTyr/nzFrI0e8IRj6zWdiY56ZosHUtofEJd0piG2tAZI4h6o37nn3nlopHys8NaH
         V4q/YJxyuICasPFZNtIzc5DekHrDGpcp3D3GDrDRmYqgGrqkddqct559Ea2wdS9eevOF
         wfBo2sN4HHCKNwx5n/1ngOtrKeM/9i8I4HIeUzO9kbhAJl6HfOP6X4pkx55s3kV3Mfr/
         T4J5Z0UwhJTOy1Sev/FRpOv28sl7bQvo4ZZC5/6Gd6N7y/tnSh0eYUzgg33agQ/qxvdo
         n6ijU0zJmx0i/MGgKQnrhMmLQFv3B+060x07TscokR5rsf9URqtMHYocAmPMTQU5ypwg
         k+7A==
X-Gm-Message-State: AOAM53166V+2EUjeJLSiwLScrSAhxOi8rWOwUKILaq0+qcHsJczLEmuH
	mhMADiyXmzhUN8C/2AT1orKjl8JmNBhb1pRlNkDh3g==
X-Google-Smtp-Source: ABdhPJzYACAhNeBki+5sxnyzl/I1D8hsXspGBbTtTNOTP9ryqsZwhQMC1+Cl+YsUD0Vcn6/Cm7DGttsgpUvEDzyH18I=
X-Received: by 2002:a17:90a:d686:: with SMTP id x6mr573260pju.8.1632766774563;
 Mon, 27 Sep 2021 11:19:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210922183331.2455043-1-hch@lst.de>
In-Reply-To: <20210922183331.2455043-1-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 27 Sep 2021 11:19:26 -0700
Message-ID: <CAPcyv4g-H20sh_CLmNFycQ28BYGmVK8q_v6-8k2-YoctqwwUNQ@mail.gmail.com>
Subject: Re: fix a dax/block device attribute registration regression
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, linux-block@vger.kernel.org, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Wed, Sep 22, 2021 at 11:34 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Hi Dan and Jens,
>
> this series fixed a regression in how the dax/write_cache attribute of the
> pmem devices was registere.  It does so by both fixing the API abuse in the
> driver and (temporarily) the behavior change in the block layer that made
> this API abuse not work anymore.

I took patch1 into for-5.15/libnvdimm, patch2 into for-5.16/libnvdimm,
and I'll leave patch3 for Jens.
