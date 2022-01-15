Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFA529CA
	for <nvdimm@lists.linux.dev>; Sat, 15 Jan 2022 01:34:49 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id m13so14852073pji.3
        for <nvdimm@lists.linux.dev>; Fri, 14 Jan 2022 17:34:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6tkGlB0DqYzjQSa/hjmq9zUBU0FufNGR7hDescp8/O0=;
        b=sJArgX2jjNnnbLclA9dGSG6JKczBSaMjMDJb7D4Y4RuJtGhpoAfTLRT9Cffu/fm5CE
         JORw7/JGAoSoaF68Ce/msUewEaMKMdh5a1JOQQ6xkPdoFbmHtHzN7TT4jgZKax5rvJT3
         RYf2avE9NCXhx1FS3yMjjg2I251Pt6pUc8JjWpsSSgdoqCP9oNyXldD9bC41RooIsK5i
         3l1rfqEWuK7XFnplq5hJ6WyrnxEasej/oud4vUutfgpyU2ashXp9DR85UwRAnPV2mL6n
         oX4MR8Elubc8Gk6njnta0Hsh3aIR/sHOuIa6OFNtGg0QTgIy8/RBOuK6BM2unVUZHVfj
         uppg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6tkGlB0DqYzjQSa/hjmq9zUBU0FufNGR7hDescp8/O0=;
        b=E/lOS3zpTMHCsbdfBsj0YajO4/YPQ/OkS124KcCg4IZZyfdDi7GumAfqr8bf2IdeXO
         qJlGkEkXFZFP3c9vJeK9qpNa0p7fRfatQDP0qZPZgEvYSCHbSRWMNbSga199lUzEmbV/
         LYCdeUVDxLVANyYD+LXiIYGxhs7PhnKNfPWk3H7nkp/EMS/qLUHWpvi9W6JeZKByA+pE
         glMvSn0UDQSUtkXNV9yBE3HLjDKMzthXpnHkmTLLcXzwtUXtaLo9kLrjO3I61ZYL+dfz
         xfCuJKpV969TmidJuKtw2pX9Gq6tVJ70C+x+Sx9rOqION9JOKnHb6hDn4UvSi5Z2JH4o
         NPNA==
X-Gm-Message-State: AOAM533W3tie4drweMALD4PdD+QaoOnDdPMexa8xNxYizbXlipIWeCuS
	nAum9JGKYGWfswAMKWDGvM+sn79nThIgQIy8p3DfDg==
X-Google-Smtp-Source: ABdhPJxTwa3njnUlGiEsJHRbi9PZs1F1gV6jzNzjhXrC5WPEH6OqtRzouyezbOyBHl21cvVDEQlgfBrmQYJMW+oRdOU=
X-Received: by 2002:a17:90a:7101:: with SMTP id h1mr13567056pjk.93.1642210489344;
 Fri, 14 Jan 2022 17:34:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220115013229.1604139-1-vishal.l.verma@intel.com>
In-Reply-To: <20220115013229.1604139-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 Jan 2022 17:34:36 -0800
Message-ID: <CAPcyv4hU5qBj1e94sO9MbNdyrsgSO7Po7V4roFgC00fOqvSrGQ@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl: update README.md for meson build
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Alison Schofield <alison.schofield@intel.com>, 
	Jane Chu <jane.chu@oracle.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Jan 14, 2022 at 5:32 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Update the README to replace the autotools build and test instructions
> with meson equivalents. Also provide an example for setting meson
> configuration options by illustrating the destructive unit tests use
> case.
>
> Reported-by: Alison Schofield <alison.schofield@intel.com>
> Reported-by: Jane Chu <jane.chu@oracle.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good to me:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
