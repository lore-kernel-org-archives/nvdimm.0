Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8B068
	for <nvdimm@lists.linux.dev>; Mon,  1 Nov 2021 16:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1635783533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+PlMFyDlSdyotYZmkf9Kx/3zxEQEZ+hPS+mrYwQmhsg=;
	b=EW0fz8Qe+ut9KmyCoRnOsO+APBwR60Zxa92KxIOw0e3QnKU/DslfH1ELoHiVCkefhnbYEu
	QOheCjtisgQ1WDDVDdsZ6TkXRMXrhS8S5d86zD8pYK3L36Z6H1AbIQBLv7Ig/obIp6gM7b
	CYbnS/lTZusUX2RMuk9U17L7r0fDKrA=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-a9X-ZBK_MQWbFaQtGBw0Nw-1; Mon, 01 Nov 2021 12:18:52 -0400
X-MC-Unique: a9X-ZBK_MQWbFaQtGBw0Nw-1
Received: by mail-qv1-f71.google.com with SMTP id c15-20020a0cd60f000000b0038509b60a93so16773007qvj.20
        for <nvdimm@lists.linux.dev>; Mon, 01 Nov 2021 09:18:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+PlMFyDlSdyotYZmkf9Kx/3zxEQEZ+hPS+mrYwQmhsg=;
        b=tCdtdSXAISCfi/9s7uYneAQxL2DTQyooQ0zZWVcSebBOL5yGN77WoZD3Fzr+vf8GA+
         rs49i+rW5hViR+znBMwAkqB81uUdWOivDXOvKXkZa8z4+fS22OC3bOke0ka0YPI+WF69
         Komgs1k7EWSoOgQta/5B1hJcQTd6U5/rBSEkMb4tiJuWdxGjblq7WguFfmb1bZGkhr50
         +zgOFq+LUokSzLaUprPotbT/NgHCtkqcQtM8lstH7yOfqT+C+2P8q0pGBmUv/rSpBKK1
         OlgnMZTVDoDMFobC0Eez/zpCOue+Hp1LW63TsEvbHRZpPbAosuiDGwagSY6R5vLS7nNY
         n3Kw==
X-Gm-Message-State: AOAM530IFLySKO6kGg2wtKZZkeDAqgYBOT20OcLwvwDKKi8RSO17dLJp
	EKRJj1z6MVvTe/2R46jOAVR2x05K4EbMb/gpKXqmJnu+fFj61NrTNVQ5ok7qff1mxcb5OTrZw8E
	6NcSSF04bAdfYHyg=
X-Received: by 2002:ac8:183:: with SMTP id x3mr31456928qtf.270.1635783531651;
        Mon, 01 Nov 2021 09:18:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx06c4hivJwjfQA8DeAKPNXipJ/hNPI/8Dli7abowyJqKsKBWURc5Mk5ISYlLWlJ3N1kL0ucw==
X-Received: by 2002:ac8:183:: with SMTP id x3mr31456902qtf.270.1635783531462;
        Mon, 01 Nov 2021 09:18:51 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id q20sm10701041qkl.53.2021.11.01.09.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:18:51 -0700 (PDT)
Date: Mon, 1 Nov 2021 12:18:50 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Ira Weiny <ira.weiny@intel.com>,
	device-mapper development <dm-devel@redhat.com>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-s390 <linux-s390@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-erofs@lists.ozlabs.org,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 08/11] dm-linear: add a linear_dax_pgoff helper
Message-ID: <YYATamEnd6imRSxt@redhat.com>
References: <20211018044054.1779424-1-hch@lst.de>
 <20211018044054.1779424-9-hch@lst.de>
 <CAPcyv4iK-Op9Nxoq91YLv0aRj6PkGF64UY0Z_kfovF0cpuJ_JQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4iK-Op9Nxoq91YLv0aRj6PkGF64UY0Z_kfovF0cpuJ_JQ@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=snitzer@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 27 2021 at  9:32P -0400,
Dan Williams <dan.j.williams@intel.com> wrote:

> On Sun, Oct 17, 2021 at 9:41 PM Christoph Hellwig <hch@lst.de> wrote:
> >
> > Add a helper to perform the entire remapping for DAX accesses.  This
> > helper open codes bdev_dax_pgoff given that the alignment checks have
> > already been done by the submitting file system and don't need to be
> > repeated.
> 
> Looks good.
> 
> Mike, ack?

Acked-by: Mike Snitzer <snitzer@redhat.com>

