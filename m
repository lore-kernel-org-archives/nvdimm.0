Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DAC72
	for <nvdimm@lists.linux.dev>; Thu, 11 Nov 2021 23:17:29 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id u11so7007599plf.3
        for <nvdimm@lists.linux.dev>; Thu, 11 Nov 2021 15:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jMxMBwZvQOQ0P3ozk3ltI4YHuakXqNt7HmzHegtg/go=;
        b=0qwRv5X8E1xcAA+gjh7gOTolXnl4bvGP8rN8bp5ZhvgvpMtTzEeGjN82SCNi9JPa2H
         vBpU6gn/8wFJMYR3UWpTq4Yp6cxt/YoDqixcaY4+V//Tib3fogx4Obp35zpjjuZC5kUN
         kolLdaxR7UgqcvmEAvbbwleEMpF5dZvUYNXJiVINQ25vu7MrVuWIunlSJU338rn7PUW4
         km50HD4VOv7ojzfHivO8ouF2KRNWj8qsMCQHVTeQb2mStOezMuYtUaWuBmbf5adGF9Qo
         huy5BzRtWJb6XxGISAzhXmKdISgyzVBksFWvX07arfkMC4TGe/Nf1RQi3VrnNC3xN5Nt
         Sayg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jMxMBwZvQOQ0P3ozk3ltI4YHuakXqNt7HmzHegtg/go=;
        b=wJYpD6+nWl+N9BBt80HFnPnTPfrPjCGZ6UWb2X9BWGwUe5yxNNj1Gn21oyJm+EUVZk
         hf5ycbteJmHUmk3TTHwbr7aJKn9dAVmNoerGyWw2WdtmhhyT+Xzl8EeD+4ufdoOIC9EY
         D+yDGpT/GZAZqYiN6R6A3gmnJNSYor8qFDS8nXw3Pu0Ty1aRG6EubOQwmH3VP7BNzeq5
         kdWc+761e5F8Y/JSozvxJbt+iYOzsW5vAGqMyuRZUx0wHTdIkaas4UrcxG9bZcZsLZwH
         +yvY8bH0hV9/K0xuADit7lXRvhzLEWtMNhnnnwC6ioIlBs+M6h5r8qBWHt70RSih5QA0
         uMxw==
X-Gm-Message-State: AOAM5307c+KRkwIW/0kKON6m8+T/wg5JM8HkdJzQLzElS40xU1LvA8KG
	0XkR3TiKAMc3TFpFXMDThj+aEwVWkc+K5NDqFdX0RQ==
X-Google-Smtp-Source: ABdhPJysyP7M4cBwMxRbatuyqgvGr8S0wnjW2nBtz4kxJfHDSdNW387zK5vTAQlx+VVxsGioP+SXTbRcfWOeih3PI7E=
X-Received: by 2002:a17:90a:e7ca:: with SMTP id kb10mr21849203pjb.8.1636672649392;
 Thu, 11 Nov 2021 15:17:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211111204436.1560365-1-vishal.l.verma@intel.com> <20211111204436.1560365-8-vishal.l.verma@intel.com>
In-Reply-To: <20211111204436.1560365-8-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 Nov 2021 15:17:17 -0800
Message-ID: <CAPcyv4i7PFNSkSk4U=8CnkOe0M1Ap2iuPWthDN86sXQ-ux3dsA@mail.gmail.com>
Subject: Re: [ndctl PATCH v5 07/16] libcxl: add GET_HEALTH_INFO mailbox
 command and accessors
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, Nov 11, 2021 at 12:45 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add libcxl APIs to create a new GET_HEALTH_INFO mailbox command, the
> command output data structure (privately), and accessor APIs to return
> the different fields in the health info output.
>
> Cc: Ben Widawsky <ben.widawsky@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good to me:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
