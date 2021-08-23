Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B633C3FC2
	for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 20:57:59 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id t1so17781452pgv.3
        for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 13:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=viPh+0UJyTwjrfYxnKuRCjFXOrg8d7O9dPBV2w1jhQo=;
        b=cCYTzhYCc+5UIWdSxQdJiIdjTBmUrpYexZ+GhELekTQzgUIgY8Dlfd7yL6Ff1yWKSY
         L+naw0dPpc2gr2+htpd2ZMVtVL6fG9Tag9Q1wCFypTa5ZGyxwB0wERVJtqEt63CM5I1I
         B2/BGEenOHr/Rq5xjs8wJco0+TEQyhdAs+Gfmq4gMeNTsBZNEsG2MXlT1mkdZRRAduAC
         q77L00UESyhD7X1PyDfxpaBGhcgkscRLg4DX6W3oRB93x6q+4EXuIszs6+T8iEBSquvY
         3SHmYNQGLqoiA3Afhrvk87/PYGSse1LS7/EARSP3v81J0/t2fvKNUnujNzgNxq8HOJZz
         S1PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=viPh+0UJyTwjrfYxnKuRCjFXOrg8d7O9dPBV2w1jhQo=;
        b=WUDA97geemblXea1Iqm440+WIyHjsHv0GBaeq9x00cJOSVdJiSIsyK8lY0ziyj9mIf
         FmMCeMvSXjL0bWIuvMPUNqBOmU+eqIDjjgKvOUHqQl7l5Mvn00aDRyz1cfD9XP2MC5E7
         D1rb35RZkU0Nn2F6xmc4PFDEaX+5eCjssjTV7V9uBGW86fEYiIVLLlgWKzZINFmkMkPj
         0KnTaCF6A8Z1tMbpbR4G3nOgHpLTzvhE5oSWG/oKPsPJo8Yowaf9lE4TbB7FaDEeTSz7
         opQo+cNF4Mo15Q6UAA2TUJ9CQmz+oLwkU4zMPBYXwVTXQL3R4f5jX9N7emwu+7paC3IH
         0NIA==
X-Gm-Message-State: AOAM5301GxJhyDfkuhTp5ckJC4xpDnqE0MZ524h3sMDI/XJG9vIXEuZs
	heVvaqlhaaLqkE2ws5+N8Ib6SkHGce/4ltmiarprcw==
X-Google-Smtp-Source: ABdhPJyTkPxH6f09SsHyv6amBiRJE33JmtsdOuXl3/Csrh5zhh/d00ls47dcJWNTFnZBryYWLMz+fEcPv6/HoulPba8=
X-Received: by 2002:a05:6a00:9a4:b0:3e2:f6d0:c926 with SMTP id
 u36-20020a056a0009a400b003e2f6d0c926mr28665609pfg.31.1629752279308; Mon, 23
 Aug 2021 13:57:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210823123516.969486-1-hch@lst.de> <20210823123516.969486-6-hch@lst.de>
In-Reply-To: <20210823123516.969486-6-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 23 Aug 2021 13:57:48 -0700
Message-ID: <CAPcyv4gDm4DQY3KNY04cgdhMCp-0j5gmc9G0E3e68BGw2kHN8A@mail.gmail.com>
Subject: Re: [PATCH 5/9] dax: move the dax_read_lock() locking into dax_supported
To: Christoph Hellwig <hch@lst.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	linux-xfs <linux-xfs@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Aug 23, 2021 at 5:40 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Move the dax_read_lock/dax_read_unlock pair from the callers into
> dax_supported to make it a little easier to use.

Looks good:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
