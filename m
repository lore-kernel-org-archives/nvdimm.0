Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB28023B2
	for <nvdimm@lists.linux.dev>; Wed, 16 Mar 2022 05:25:39 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id o6-20020a17090a9f8600b001c6562049d9so1408294pjp.3
        for <nvdimm@lists.linux.dev>; Tue, 15 Mar 2022 22:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4VXLa+bQza4asNsvRsBeTx6o89c2ufs9/OaL35zL23k=;
        b=uHN7xSsgP880Hr638C0NbhmgBDr1CfM1yG6kEOD+6lzRYu+6Ng8zeZ/y7ulSUSyuKv
         L8LhSZoLFNbvyfpYx5ZKy6xLGdk73K/VxduAug+WgAfKdgmQCiy4+j7atUrgzFw/wlcn
         7KVvh1AA0dsoiXhbO1yMiLBcu4P6+AKxWLMnFwJFyHUb8BHN3QSYiI+MPW5zXHfhaVDq
         uekLzQBhIjaEx7Pjxt7Lz0JEIgw1Rj0JYw00lmqdUT25AtDtJNhBzRgOk8Wf2IVuH6AA
         Q0KwikoxBc9tmB0j8WPdAL6aUoKishHwicXPdYL16oMwfUE7LoHwojUiSkCz/1xQsULi
         9Ijw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4VXLa+bQza4asNsvRsBeTx6o89c2ufs9/OaL35zL23k=;
        b=VcaCWNMvvePOaPiTtTYuweB2WZXgxniBs3q+nI20PEsPpNC/80ElFgB2F/hNdFYQvO
         KOKLoPW6X419YlvsqBVrDUopkqDwWHYfQpu1xGFipjG1yQR+9IrgRGjs6seWbziTDjky
         GwLNYy/bGuWHcmvvwRBABXD4yoE52jKqMr0wIM9j68YhlgurLT+kJPc3/4qfvQM4p/RH
         1GdY/0gypMnGZb6OpnRjzExNzilC8qGZ4Kp6uclzNoqp0AIZh8V5bgNU6UJMfhi7s8m9
         K5emTJ4vXmRyBcOpbmsint8UwdFB9YLqq62zSlWXFLNUC+xDjlZLzAFElkhGyf26SH/4
         v5mg==
X-Gm-Message-State: AOAM530Z4VrSDW9jwEAHaEaRyUAowb6L/RmbrSPtgBWgtwc8N6PRaWzZ
	Mv1LkZN/qKO3Yut1uwQBcG4EEL5ta5JwV2UBfTRf3Q==
X-Google-Smtp-Source: ABdhPJxWKW3AaOJQwkC6iKr2VdTaQ4Ug/eP67T3DupZkrcyYpkyTp8r3JNUSmK2Jgs3wQY4zwJEVb1iDQXK9NFiaXik=
X-Received: by 2002:a17:902:7296:b0:14b:4bc6:e81 with SMTP id
 d22-20020a170902729600b0014b4bc60e81mr31522519pll.132.1647408339183; Tue, 15
 Mar 2022 22:25:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220316052133.26212-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20220316052133.26212-1-lukas.bulwahn@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Mar 2022 22:25:28 -0700
Message-ID: <CAPcyv4ita5JmK4noL0euebNgLDYYb6fmnDQZfksTr=FOqtqe+g@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: remove section LIBNVDIMM BLK: MMIO-APERTURE DRIVER
To: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	kernel-janitors@vger.kernel.org, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Mar 15, 2022 at 10:21 PM Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:
>
> Commit f8669f1d6a86 ("nvdimm/blk: Delete the block-aperture window driver")
> removes the file drivers/nvdimm/blk.c, but misses to adjust MAINTAINERS.
>
> Hence, ./scripts/get_maintainer.pl --self-test=patterns complains about a
> broken reference.
>
> The section LIBNVDIMM BLK: MMIO-APERTURE DRIVER refers to the driver in
> blk.c, and some more generic nvdimm code in region_devs.c.
>
> As the driver is deleted, delete the section LIBNVDIMM BLK: MMIO-APERTURE
> DRIVER in MAINTAINERS as well.
>
> The remaining file region_devs.c is still covered by the section LIBNVDIMM:
> NON-VOLATILE MEMORY DEVICE SUBSYSTEM, and all patches to region_devs.c will
> still reach the same developers as before.
>
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
> Dan, please pick this minor clean-up patch in your -next tree on top of
> the commit above.

Ah yes, looks good. Thank you for the fix up.
