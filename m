Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64A82F26
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 23:57:17 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id u130so17302154pfc.2
        for <nvdimm@lists.linux.dev>; Tue, 01 Feb 2022 15:57:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YKWvBgsOWpej0zYClHdQnP9nVX7Q9Dikupwbl14Wx7I=;
        b=MOoQ0FssHYYaokVx7KujgLCYFAMMv4AP+5WY84+i8FJMuddPxI2kbY09cbGy662b92
         1UcLQ4UbCwhcvtCHiYqwFu9RAY0dsciqkMB9HMis2+AMwvxFc5wfqJov5Htcu8YMKcNL
         3CdiT9d4mGYmYZFCU8IfP/uToM4KxfzE6xWhhByOWuQ8CN4085oPdGq3xRZNHX2XjIqE
         kfu5mtlI/CfWi/tFdNjlWdl6Ubgl0/BZp9G+l3skv2Z3gkzbAGTOyr1gXOsdlts8vr7P
         2eQl/ayhVPtEDAVfRBc/1rjHqlGbz+PKjy9keBaQE5hQ1dc8Xux9ZF+wPHKIb6UzGaBE
         p9iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YKWvBgsOWpej0zYClHdQnP9nVX7Q9Dikupwbl14Wx7I=;
        b=FVDlZxj0UJ3vi2WIeC6ryPoND7Zta3roJ1W35kz9oO16pkqakL4rp6l+y94RHYtahw
         Kc1fs0NnYqL7C6em6X51TvpDDrgoRkQSD+ykrFt8teYbRTA4iydnSMXlsweamMafnbN9
         Iy3p1cBj/7OitKzjeZ95GU69oV89YQ5bMaHOHj3a5nTgCUJsHu6sLC3EeGhnw0iasZul
         QK9iPodMTcxEr9rxcmfhj+ODW8SpxVIDKCzs8e0iYBtnZzvNmWweC+Cq6BWEFRXeWK0x
         JrGZoTp7XoKuJbRhbddjzdQNOA/zEn38oFxmFETQ8DHJtk2yfw0sObIz2YOiikw3p2e/
         b06A==
X-Gm-Message-State: AOAM533qz3aBsRhyqvarfGVTog5B3LqkrtYUZXrwVQ/vj1Cj6O52Xm30
	KF3pEzXFKgZZj7ZsVpwE4Px/xrq6LnTaPe9llCnQNg==
X-Google-Smtp-Source: ABdhPJwDHic741AiY62VdhZ8IkHnFn3u4W6ArULjeKlwuXnvNJecPT/0JxNtWKYkU0aKk/Zl0E/LRlEuiy0r1ikCKtk=
X-Received: by 2002:a62:784b:: with SMTP id t72mr27614119pfc.86.1643759837270;
 Tue, 01 Feb 2022 15:57:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164298428430.3018233.16409089892707993289.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20220131184126.00002a47@Huawei.com>
In-Reply-To: <20220131184126.00002a47@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 1 Feb 2022 15:57:10 -0800
Message-ID: <CAPcyv4iYpj7MH4kKMP57ouHb85GffEmhXPupq5i1mwJwzFXr0w@mail.gmail.com>
Subject: Re: [PATCH v3 31/40] cxl/memdev: Add numa_node attribute
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, Linux PCI <linux-pci@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 31, 2022 at 10:41 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Sun, 23 Jan 2022 16:31:24 -0800
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > While CXL memory targets will have their own memory target node,
> > individual memory devices may be affinitized like other PCI devices.
> > Emit that attribute for memdevs.
> >
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Hmm. Is this just duplicating what we can get from
> the PCI device?  It feels a bit like overkill to have it here
> as well.

Not all cxl_memdevs are associated with PCI devices.
