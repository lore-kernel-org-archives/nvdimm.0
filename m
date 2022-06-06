Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72F37E
	for <nvdimm@lists.linux.dev>; Mon,  6 Jun 2022 14:10:47 +0000 (UTC)
Received: by mail-ej1-f47.google.com with SMTP id u12so29224225eja.8
        for <nvdimm@lists.linux.dev>; Mon, 06 Jun 2022 07:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:cc:content-transfer-encoding;
        bh=zcfwBnYsaM3osnPpLQRxR1JrABrX/zB0kh++woByQVw=;
        b=gEpMt7Yd2UxBYkCte5IR1tgFlFVQEJ5SylH2/PBFk99wiIMXMkM+sU44fPiSwHBSIa
         IMN0bB6BoqeG1sEJlrPjvDJwshD0q/AyS0IJHSN0P9Ag849SN82OU8Ve5PJzspiKPaW1
         ixl/BLksjnyF6+Q+zGJYXDzeZpi/LDj+JclfL1cyrON5hgnvjaUXMyC7nb1ksactUBIH
         jb2tLQZDR3UZzGNzC9dAr2e1XwZYvkD5WfHeYwhKxD+AUN/NVrWM8f/WdIoZfPQ/vOJo
         Hy5xj1R8bnKIgXu+lNCl9xqLdJ5CDltw8jt+jMNUJK7Q1MpOo0KjmNKdY80vONgP9gY3
         g/vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:cc:content-transfer-encoding;
        bh=zcfwBnYsaM3osnPpLQRxR1JrABrX/zB0kh++woByQVw=;
        b=NC19N061eZKT0lT/B+NILUx8fe/hsRxTLDP5m7sA52pmU7sQgPpkDoIYItCxm8ddKA
         eLxQCpDwy4xmfQOSFkYXE2Q1NDBLSiBjSS0nstFZtYzeX9cVw4Kz4pwcbwehAq2q659s
         DcZpForI6IyhMAahemAUNBbcI0VsVJ8iAhkotPbiD4GnWdSO4LDC39cIvNur2u3gqcoA
         Bva9ISJ7F5fvq0i1ssm83XgH+j0V5+Et3QORmK4RvpopNKCHAFb3n0B0epDZ+JCxiWPV
         78KqaGH6SPkHv4xAB/Jfh05sExvd9KY5+86vgMEIL/TUhptU604naWIiRtUNvwXSMSTr
         W+pg==
X-Gm-Message-State: AOAM531go+zFfeAzlfgsASzcl/9fkZ1LCuL6q7vAnnT8lSvyGFPXWf7o
	GA0JLcicQVW0svAHpXRXp8w=
X-Google-Smtp-Source: ABdhPJzqBAw+J0OHGwBe1PkTWA7yEhL5aB2O9MeJxPiApU6qXMja7NqcmfnC2G25AjnP5JFxsUOEog==
X-Received: by 2002:a17:907:16a4:b0:711:c9a7:dc75 with SMTP id hc36-20020a17090716a400b00711c9a7dc75mr6290181ejc.542.1654524645895;
        Mon, 06 Jun 2022 07:10:45 -0700 (PDT)
Received: from [192.168.0.210] (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.googlemail.com with ESMTPSA id e1-20020a17090618e100b006f3ef214dc3sm6357044ejf.41.2022.06.06.07.10.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jun 2022 07:10:45 -0700 (PDT)
Message-ID: <a1aab4df-9e1c-793f-5c3d-d735e4f4fb57@gmail.com>
Date: Mon, 6 Jun 2022 15:10:44 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
From: "Colin King (gmail)" <colin.i.king@gmail.com>
Subject: re: fsdax: output address in dax_iomap_pfn() and rename it
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, nvdimm@lists.linux.dev,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Static analysis with clang scan-build found a potential issue with the 
following commit in linux-next today:

commit 1447ac26a96463a05ad9f5cfba7eef43d52913ef
Author: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Date:   Fri Jun 3 13:37:32 2022 +0800

     fsdax: output address in dax_iomap_pfn() and rename it


The analysis is as follows:


static int dax_iomap_direct_access(const struct iomap *iomap, loff_t pos,
                 size_t size, void **kaddr, pfn_t *pfnp)
{
         pgoff_t pgoff = dax_iomap_pgoff(iomap, pos);
         int id, rc;
         long length;

         id = dax_read_lock();
         length = dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(size),
                                    DAX_ACCESS, kaddr, pfnp);
         if (length < 0) {
                 rc = length;
                 goto out;
         }
         if (!pfnp)
                 goto out_check_addr;

The above check jumps to out_check_addr, if kaddr is null then rc is not 
set and a garbage uninitialized value for rc is returned on the out path.


         rc = -EINVAL;
         if (PFN_PHYS(length) < size)
                 goto out;
         if (pfn_t_to_pfn(*pfnp) & (PHYS_PFN(size)-1))
                 goto out;
         /* For larger pages we need devmap */
         if (length > 1 && !pfn_t_devmap(*pfnp))
                 goto out;
         rc = 0;

out_check_addr:
         if (!kaddr)
                 goto out;
         if (!*kaddr)
                 rc = -EFAULT;
out:
         dax_read_unlock(id);
         return rc;
}


Colin

