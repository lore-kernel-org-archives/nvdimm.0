Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4FB2F47
	for <nvdimm@lists.linux.dev>; Wed, 13 Apr 2022 21:22:15 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id c23so3065003plo.0
        for <nvdimm@lists.linux.dev>; Wed, 13 Apr 2022 14:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4omrGBh4rMwEJEaoEHmM1XJRtehHXwGUeZy3KwoVcfc=;
        b=JHwn8yeQUIn0NLauMr393piIbTf3OTdCg4uXX41ukSp+4RGipfV9bBe8uRCqMHQlMX
         9S25rGSI3H+jBJ3AxQi2O0+xwcLfAeUPoncKPZXif+9g/IDp5dFHaydwnhjQANt1yLkX
         GyJs2zPbkf1G739gFU7CyFtLQ+Hj+1YOi7cWu3kWoOrz/uV1Z437+TvYQ0lzA9rafhT7
         uJIpadx77lSEA+Ry1z4neKG0sFKUF6fjIWOksJjovqetFl6uM2NWsDNj2hQ4DaJHC6NM
         AT+4sAQSWhMPQElg5pijJvYjZFQevAs1L2uYm7r9kasb7Oo/ecs3QY3jm2SnWWRZMTyP
         gytg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4omrGBh4rMwEJEaoEHmM1XJRtehHXwGUeZy3KwoVcfc=;
        b=BlgqinXDpKIY9u4+Shgc+mDBgoTC0dK32RFue4hEwuUOA5ASWfBmYaIR3lrrLFqUkV
         rbL9k0e3DjibfG37MNOtjy6MzMI0SwyY+ERzlfGXeTSVlPDFGEJcIW/ck3Sgt69jEd04
         FMcitoaNZ7JYZU18PvSZ2AP3WPFLi2UGPzMlWIxYgnBxmPJx+yfABXgZ/SJs00daKCrK
         Vb/8qM2Xz98kFxU7wFe7cwk5Ud2qO1lZanzHYg+a1hIz8CHZ+EG60csl4/DfJQNHqcb1
         MvSdqIaNGcsgIxA2HXrvs/DHD5PxC8D5SRuZyJcxcdhwnY7XeoHk4cl57NQpaOrmJwvk
         AxVg==
X-Gm-Message-State: AOAM530aYm0SmpXCw512YBMVFpm/9mCxUJYUWEV3M7cecADP9zT59aiv
	W+ivQqRQ4TXddQn1/px4Gig0XbqA/j9k0jgdx5M/Kg==
X-Google-Smtp-Source: ABdhPJzJ1KuMUw+23/AIxQgzDx5RbhtEYcoArH9fBDCciyTF6G30/td30jwZCE13hnZ4ygVGIROTwReA5Afzf8G+BBY=
X-Received: by 2002:a17:90b:1804:b0:1cb:82e3:5cd0 with SMTP id
 lw4-20020a17090b180400b001cb82e35cd0mr743163pjb.8.1649884935282; Wed, 13 Apr
 2022 14:22:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220413183720.2444089-1-ben.widawsky@intel.com> <20220413183720.2444089-2-ben.widawsky@intel.com>
In-Reply-To: <20220413183720.2444089-2-ben.widawsky@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 13 Apr 2022 14:22:04 -0700
Message-ID: <CAPcyv4jJxeQ4MxG=coe+J-qsdDVZxP7f5oXSR0QkJoJ0d2tSdg@mail.gmail.com>
Subject: Re: [RFC PATCH 01/15] cxl/core: Use is_endpoint_decoder
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	patches@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Vishal Verma <vishal.l.verma@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Apr 13, 2022 at 11:37 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> Save some characters and directly check decoder type rather than port
> type. There's no need to check if the port is an endpoint port since we
> already know the decoder, after alloc, has a specified type.

...a smidge more clarity:

s/we already know the decoder, after alloc,/,by this point,
cxl_endpoint_decoder_alloc()/

Otherwise, looks good to me.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
