Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884F872
	for <nvdimm@lists.linux.dev>; Mon, 20 Sep 2021 23:37:33 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso614469pjh.5
        for <nvdimm@lists.linux.dev>; Mon, 20 Sep 2021 16:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fF0TCTjeEHkCVv6xpdHuJdavcWQVB5eohqIs8o03UdA=;
        b=P5C3ARdy3+RMB5+/3T2u/5p624EzdMi+ZOVC/bDgjdkc5T2B0TDDI6KuW+OMeZQfVV
         mc2qqOApF0mOumKhbxeUZBHAatTJ1GAH+sZHLiCPNVnocX7/g2WwalLRkSr73pHe4Rk7
         /X6WFPMtP2tKJbIi7SnCB/jNqAL0TpXFpqfNY/OLfrPE7WtXmv3CEFXBFIwWPZ/FKYpH
         6sbhq7KhYs0UBrHvenrrOi1k5l1+lgbYwP4KFYyxt77O+LdMKxmDgPwYti8G8ua7j2xg
         a8dKy6pSzq8KlM11K+8DBom5vfN3OBlHuQQiMbaUlVy9q6f7JGm9M6K3f4ovMh9LQEbK
         oBfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fF0TCTjeEHkCVv6xpdHuJdavcWQVB5eohqIs8o03UdA=;
        b=3z24miBgKbDIi5uAMyeDoO776g2/dJyE3EJhZHH8l6+uqzMIdKbEmzD8PgNS2fyPSH
         5WU0vFoxq42gYG4pC9OhJu4M+hEdE8ZZigHp2H7Pjm5HYIFiImQ9DrSctmTmUy8IPeUa
         BBTNzFdpcGVfrTpf2u+x3vg8RMArvSFgIjvIFfqY21dVDNEe2dOeYvxdDPKX8+MJtgQz
         N5F3CzfXuMrHazc73DsHSjDFPJyRuyPD4p8v5hGq7IoHIri4eJykGs1W+n0CSB3rOjrX
         rYuv58sZd5NiX5w8Kzpcjx81pL6X5hLyCR+52WCjWNOyDssO3bCs1a8WhZLzP/4km+a8
         m+Nw==
X-Gm-Message-State: AOAM533po1i36uDx0Yem6ZyYjeYHbW3Qo6+1RZkBOGwR5nAOXjugEjJP
	B/HCHMCZbeB9LT1+9KJ3tS7Dok0ofNFkQSQbTh2uPg==
X-Google-Smtp-Source: ABdhPJzQO/CQq0iHCsKH/QNdbS8qNKnmFW6qjPLg5q6lCcSBWHVGyHuGIILH0iBAMv7pOzaCIxTvJ+y3tKSJ/T/m3dY=
X-Received: by 2002:a17:902:e80f:b0:13b:721d:f750 with SMTP id
 u15-20020a170902e80f00b0013b721df750mr24772956plg.18.1632181053137; Mon, 20
 Sep 2021 16:37:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210920072726.1159572-1-hch@lst.de> <20210920072726.1159572-3-hch@lst.de>
In-Reply-To: <20210920072726.1159572-3-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 20 Sep 2021 16:37:22 -0700
Message-ID: <CAPcyv4g+KdhFpr8Prn9Wg2E7k0OeRSbs2siNDgJBH9h0RSVN2Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] nvdimm/pmem: move dax_attribute_group from dax to pmem
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, linux-block@vger.kernel.org, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Mon, Sep 20, 2021 at 12:29 AM Christoph Hellwig <hch@lst.de> wrote:
>
> dax_attribute_group is only used by the pmem driver, and can avoid the
> completely pointless lookup by the disk name if moved there.

After the additional fixups that 0day-robot found, you can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
