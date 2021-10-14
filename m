Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6E72C83
	for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 23:33:41 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id g14so6844549pfm.1
        for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 16:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2Jswe3R1B4VfWqfjRbG6Ud02Qe/FCGGNBzIi1gtFNqg=;
        b=RK5lLJi3+ze1eOuntTw/jCBXxTeZ97uZy7OvrLculC2mlbmsT4LFUZXm69fHye1O3A
         MA8+EyMkwblo0zw1ktT5n3TEW/aOsJ0C3tWrbg/wQJfgeVF1sjvtcnTu6ZROOr3uJnc+
         GRWcAcI8BP2wrqFD7LFgq3Z8qNUe5R5AamwLQ+R5IsG78kyfzireb/pib2tLmqNF6a0j
         4DfnvqkljjiqtHystR1QnuYOc1SlfUkWoEdwzo2FmhOyyvmSvIcuzSQU2OjbIkypDiWj
         6MzfCvG/Zb4yYf3tcWwiO+FWmQLjUSn9LNzXaejzJMihVbQmI9qfFXpYGeaBIgSsXZjT
         yTsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2Jswe3R1B4VfWqfjRbG6Ud02Qe/FCGGNBzIi1gtFNqg=;
        b=y0tHdJ/N8KSCahIHu+vNTtUxuwel2r3FvgrloqV6LPC3udfDz9pW53DEystpB2gBs4
         kYTXaLHFUOny4FnBVOXrUrPzE+NX/+fwyYsS2zF/T33kXOOx/cUhsCPDlfkkFknGT10p
         72AwRgyHXCl04GprfTWFGAVNaA0izbEF5D7DMJo9Vt/mIu5VbDqUyU5P/wDDbmU4Olwp
         QAfz2VZdwLAuRIJDxj4O2wcY6vLgEacXOJB1SVd/XoIIV78dxCHhy539w1I1jHAQCkve
         AVyP7TXzBxOJBVYwGBiy/3e3o7kExHzbxtwZ8zL1dfTsR7I0xt8mjMbWsYmc2p8U2oHn
         SOsQ==
X-Gm-Message-State: AOAM532o+Hbim1PrP6HB/5KfY0eHsmI5jdxiPoDz8mbY/NrvcreVH+Kr
	6+3Q3Lq/rWwUHoquCKFfLt2B+7FDxemCQ3S3REpA2A==
X-Google-Smtp-Source: ABdhPJzT+hk/s1aZs1TKlM05Q0fxCTVYdLx3Dr/d+atwp+D7aq7+hU7rOlyr3IE2RJlY6KYZze+/nsI2UZlZa6YHcSI=
X-Received: by 2002:a63:6bc2:: with SMTP id g185mr1632779pgc.356.1634254421450;
 Thu, 14 Oct 2021 16:33:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211007082139.3088615-1-vishal.l.verma@intel.com> <20211007082139.3088615-16-vishal.l.verma@intel.com>
In-Reply-To: <20211007082139.3088615-16-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Oct 2021 16:33:31 -0700
Message-ID: <CAPcyv4gO3XHgS0Agxgg0ftVPZp5rdQKW-U8KKU_BVaaWgPLGiw@mail.gmail.com>
Subject: Re: [ndctl PATCH v4 15/17] ndctl: Add CXL packages to the RPM spec
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Ira Weiny <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 7, 2021 at 1:22 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> From: Ira Weiny <ira.weiny@intel.com>
>
> Add CXL related packages - the cxl-cli utility, the libcxl library, and
> development headers to respective RPM packages in the main spec file.

LGTM

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
