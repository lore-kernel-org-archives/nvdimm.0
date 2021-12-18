Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421A1168
	for <nvdimm@lists.linux.dev>; Sat, 18 Dec 2021 04:03:50 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id 196so266095pfw.10
        for <nvdimm@lists.linux.dev>; Fri, 17 Dec 2021 20:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W0koHLqXhrl+3mpWIPBCCUNbtUp09PexnvWvCWxx2/g=;
        b=Zl9hzCSkEZc+AwfQUG9sCXMztY1nDpWKb0BI9/nbS656BinhMj5dVKcsZ4eSAMbWvT
         V6Pb5udEzcM3x833bDCbsQjIPwqQyURVvj40HWJXyLFm31yUCxdXWl5dCKMzVTaSovMT
         t9wqiNi9q2/3ovNPFvb5lD/aD54/K7FkAN+3Whalr5JzKfnIgXmgCZhbfZEt2/AeC852
         RGRRPcI9FdNXctTCwyJwdTuAKtoRfowCjBuhexczCPBoEzjNeUcHXyeIv8qwC0a6hJlp
         bzbYX16bksi7mbxs26EgFIY2vwnTwvIBWw7lzftBu9RSs94yTdrqWPPqWaZtdz7MGPic
         xz8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W0koHLqXhrl+3mpWIPBCCUNbtUp09PexnvWvCWxx2/g=;
        b=2sihn5QI8jeibA4b3wWWvLLwqa0VHr7r1/88lZP/IZ9aN2XfuykkEPFUe6fgirqmJx
         3Hu1yWGwYxoWt8TyLf1H6wcGHKb38KmFzIOsWI2KvMJlB6G+O60jZ7ERJzhzPOOkPBxu
         l59cGKPBYD499a18PzRB+uYpLjQjnwN/f6ywY4ycwIHiMq8ZAkEbgcN5iMzK6zROfnH5
         AmrxyOBqMpcWWXvFU6/zahdoRivKvTaYoyB1Skt8kk07kK+YgQtxMMJuZKHwzYljadm0
         dXnjyzOtMIfu6fnuUq3kAdfuNYp5selxrJsD5DMM+4kdER5H9ReOzNJS7VCJ6nNKgMnu
         sVzg==
X-Gm-Message-State: AOAM531HoXlPuAYP7+hJoZxcAztvZH8ElR8RTXJbYXyRZTWsD4qLfGJi
	fsHwqJ/jGjmSBXW6544qlOhaXy4UVngrKkOYEC3bDW1RUvk=
X-Google-Smtp-Source: ABdhPJzpOC4A4ONDuMzeJA9J2zGq0pMkU0o5OzqPXaIrPaVmwWM7FZ8tYyQ/TE5Rb/iATl0byQnljmE33p25n1QNJk4=
X-Received: by 2002:a63:5357:: with SMTP id t23mr5647190pgl.40.1639800229638;
 Fri, 17 Dec 2021 20:03:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211218035922.347380-1-vishal.l.verma@intel.com>
In-Reply-To: <20211218035922.347380-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 17 Dec 2021 20:03:38 -0800
Message-ID: <CAPcyv4gBHOJf_5xkiKFas4Z44ujbpEbQymfr=BfdPzggGMKaXQ@mail.gmail.com>
Subject: Re: [ndctl PATCH] util/parse-configs: Fix a resource leak in search_section_kv()
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Fri, Dec 17, 2021 at 7:59 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Static analysis points out that the memory pointed to by 'cur_sec' may
> be leaked. Fix the missed goto error; vs return NULL; exit path for an
> error condition here.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Static analysis scores a point.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
