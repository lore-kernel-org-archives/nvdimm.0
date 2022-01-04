Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FBC2C9C
	for <nvdimm@lists.linux.dev>; Tue,  4 Jan 2022 22:56:05 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id t19so33465289pfg.9
        for <nvdimm@lists.linux.dev>; Tue, 04 Jan 2022 14:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QDrla7Rgv/PbJy5q1B/gTLicO7LUJ4Uh87OcS/ewnKE=;
        b=UnQWpQr21b08H9CCzMDJ58NV59i32gSxpHT+QzAwkrO4OAmJ//j0XPMmeqp9ezNcVD
         wc+LG30An/agayNvl+NJHt6YBjXm6O408MGhsYl9h7mvor6IRClKKERwR+G7NA4rrrxD
         YEhHssP/S9/5wHZr2A6Ly4Y41OVCTab/vh3T/47v9/0Zl1rBfzSzhFxVXZwEhpw+OAlb
         lHdxMEYtx8koB4EsWoqsmItGdKo9eHAhy8j0Jf078FeDyQ6lYITt2LM67Tetu3wYlKWG
         m/cVqQ6dQgccJh3/k7W1YuPpUIzvCRVDDwWPDHRnOkQXBz8LQPfn4BPfDg0xP1ivy5we
         53Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QDrla7Rgv/PbJy5q1B/gTLicO7LUJ4Uh87OcS/ewnKE=;
        b=S6pNtNhFeFb1bJFWywcc9iFxVf7fNTScE4Zks3LpuliKdzJZ2tUjQdTa6Iy0kxae51
         ec9FUIqosFtW7Nr3CKe9yrTMi2hZdbwjGEp2VkpgwNyvElqcpoQvq7O6q6jSdtt4cjJy
         3edMAffTI6uWs/bOkwrFO3kZamOz55RxeNmUND/42tb6XLHpTk9LKSxfvIMcOVX66Ezw
         T2+89CjXJapeXXq7aHV1WAwRv0Sf85Yaj1Cu0t+W+JP3boYKeUd70AnOfH7S5VbBb+Ee
         VOd6qkGSQGWj5l79CsUgSc/09zz30qzazL8qsd1Ta8yhjUwRBdCykZ0FAS12QP8hiPxS
         lepQ==
X-Gm-Message-State: AOAM530mc5AYneb9mBWkgOrh9L32xwdpi5q38HThR9wRCRdBMhFyt1Wv
	vBVGZWb3jinhBa3nmQ+HJwK3rfwGx40S+zqsE+/qCA==
X-Google-Smtp-Source: ABdhPJw+Vos8Ml12UKdWDConJMoM6GI2KsSQYifbyzS1cJDllpf9uH/RB9uuvuXF/vjErHmErkc/FI0EcnSktAhTHJQ=
X-Received: by 2002:a63:79c2:: with SMTP id u185mr904600pgc.74.1641336965053;
 Tue, 04 Jan 2022 14:56:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211226143439.3985960-1-ruansy.fnst@fujitsu.com> <20211226143439.3985960-7-ruansy.fnst@fujitsu.com>
In-Reply-To: <20211226143439.3985960-7-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 4 Jan 2022 14:55:54 -0800
Message-ID: <CAPcyv4jVDfpHb1DCW+NLXH2YBgLghCVy8o6wrc02CXx4g-Bv7Q@mail.gmail.com>
Subject: Re: [PATCH v9 06/10] fsdax: Introduce dax_lock_mapping_entry()
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	david <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Jane Chu <jane.chu@oracle.com>, 
	Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"

On Sun, Dec 26, 2021 at 6:35 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> The current dax_lock_page() locks dax entry by obtaining mapping and
> index in page.  To support 1-to-N RMAP in NVDIMM, we need a new function
> to lock a specific dax entry corresponding to this file's mapping,index.
> And output the page corresponding to the specific dax entry for caller
> use.

Is this necessary? The point of dax_lock_page() is to ensure that the
fs does not destroy the address_space, or remap the pfn while
memory_failure() is operating on the pfn. In the notify_failure case
control is handed to the fs so I expect it can make those guarantees
itself, no?
