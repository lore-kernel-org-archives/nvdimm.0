Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7B52C88
	for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 03:41:13 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so1200820pjb.1
        for <nvdimm@lists.linux.dev>; Mon, 22 Nov 2021 19:41:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yuisy9zT1caIpoCJEL+LfomruK38WXIi70xmI7lYDdI=;
        b=Y08/be2uy1a6FHo2yuq5V6dIERIFe+eeTyXLXTKFjFxfAYARUBwDdqRv9XulygxcF5
         4zZfKtYGqV6eckQSPyIqI+Gn3GMQFWIP9FXR6DHHwN+9GDnZm18bVZGFa88rvhT3Zhp8
         eBxG8SJu0LWqmuhUvXdN5Q8E0N7Fv2c7+1ZOSnPpTxrI3q5JIXNMGFvAj0k+TWuhQgQG
         tLoyO8DVm7L0ndxV5dBnp+whJ587dE90ANm0vqzPKJbxSHtsEtd3ERFpgMcAPItk+09G
         dbm69RRAjzWoV6a6vlvEHV0tkZfEJqiOGj5p0uoKbINk6WBGJnIFfCSAm3gIT8TG78mL
         kVoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yuisy9zT1caIpoCJEL+LfomruK38WXIi70xmI7lYDdI=;
        b=R6t2P8OzeTh0DC8IwTPtduuP+cUJIi+MzCsk4PxIYCZbbihPlXZOsz3OvEBvGpSjRz
         y3C8ryYHOxkpCwcZgSloB8M2+nqAynOO10HL7YRk7IaDV8C35h/vEWZNs5GMSECM2sM+
         DH9SzViOyePvYKPJiGo9x0OAIhXhVrild0dDJUNQOneY2XXQHEHUr2eDl004vsGOuRtM
         0wzf571xWxPxkXNDMNkeSdQbfvNqr76r3W8cyT/qcu6olv/FwvDpFUeQNXickc3swUVp
         HR3VOQBt19QEkuOMI/S4oNjqy6oxxJmT7lKZcRATV0IY125ak4o3eUnq6NcWXi5SUt2m
         FFoA==
X-Gm-Message-State: AOAM530sEYbfF93z5CnTXgN8Z54F1pplSHDZLNTqd3tWANgHCpzy8XSv
	fGaReHAHuK89BpMeCUinWvq4d4aUdteFj172ue5a+A==
X-Google-Smtp-Source: ABdhPJwgBzEQtBEEt5JgwawqvX/CZbZsaXh/qAQWeeflxeagBI6MsJ+fyqKdfOXHrkiL5G4d5gMRZlq/mNM2Mj9gTds=
X-Received: by 2002:a17:90b:1e07:: with SMTP id pg7mr2525502pjb.93.1637638872640;
 Mon, 22 Nov 2021 19:41:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-7-hch@lst.de>
In-Reply-To: <20211109083309.584081-7-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 22 Nov 2021 19:41:01 -0800
Message-ID: <CAPcyv4imYR=NLizABpZA+gKH+amNQ6jcVNQhtF+1jyevdWzmBw@mail.gmail.com>
Subject: Re: [PATCH 06/29] dax: move the partition alignment check into fs_dax_get_by_bdev
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>, 
	device-mapper development <dm-devel@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390 <linux-s390@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-erofs@lists.ozlabs.org, 
	linux-ext4 <linux-ext4@vger.kernel.org>, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 9, 2021 at 12:33 AM Christoph Hellwig <hch@lst.de> wrote:
>
> fs_dax_get_by_bdev is the primary interface to find a dax device for a
> block device, so move the partition alignment check there instead of
> wiring it up through ->dax_supported.
>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
