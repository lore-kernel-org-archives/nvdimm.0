Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14503184B
	for <nvdimm@lists.linux.dev>; Mon, 13 Jun 2022 17:54:54 +0000 (UTC)
Received: by mail-ed1-f53.google.com with SMTP id v25so8240580eda.6
        for <nvdimm@lists.linux.dev>; Mon, 13 Jun 2022 10:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0yE1F+T2LeAVJ2bFwOtJHGbp283h9GhemqSHAeGwktA=;
        b=cV5JPzOcrWUkY/YCBj01CplxNVk0Ypz2tEFigoKe7aUyACwfxpLidnfRJxQUvCHXB8
         hXeDqzdFDhPl5UTeyCWepHZO/sI6ZgbBgwwQXwmZisuOyhVixvoN3C2E6lXFMJOFc09R
         /Hv3Nw2iClVxh/V9udd7r9WBzL/nRXXjTHk6I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0yE1F+T2LeAVJ2bFwOtJHGbp283h9GhemqSHAeGwktA=;
        b=LGEzImGBZpFmm1f/Rkn85yydNZ9hfTxHZU7tJND9UzkssR62qaS+ofI19wnUaaTJEU
         O8BeAezr/fhZIjacjPzhA5eJdKek1KpWHlodA/oanRDJMEYko7weAm9UqL6otNrYDYzr
         qgiCfvny+NIGAUJtKFaoZ2VoBOAA2M7FlozFy3B027sQl1sXFR/MeGRozy378hz7WadO
         7OAzkoUbVkZkr1BvDzVFxE7NTC4bQSf2YVMJSX/NIBt9UkyZ0T6verBIbWMR8LpczD6A
         8r2b66EyNbipfxJaVP5m4bH5EYeuLrNDRn7SfBgr3NcGKkdUQJGkZoRosII98WPoQ+CX
         rcYQ==
X-Gm-Message-State: AJIora8MPM6PR1mRqpdWjk+aO4H+5cCIEHin7sFl/wqIxvYKzBhEXLsf
	+iKaKZzZngcyKd6L8FO6kefRs1eYBzla4dir
X-Google-Smtp-Source: ABdhPJyk3u1//KQT+LyIpWqmRrKM1NbN+9E4UuQQQWnOHA8ykkZvyo9BIlCjl9/5LXkEyp1QzFOwnA==
X-Received: by 2002:aa7:db8d:0:b0:42e:1cbc:5e28 with SMTP id u13-20020aa7db8d000000b0042e1cbc5e28mr1044895edt.366.1655142893090;
        Mon, 13 Jun 2022 10:54:53 -0700 (PDT)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com. [209.85.128.43])
        by smtp.gmail.com with ESMTPSA id r5-20020a508d85000000b0042aca5edba7sm5330857edh.57.2022.06.13.10.54.52
        for <nvdimm@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jun 2022 10:54:52 -0700 (PDT)
Received: by mail-wm1-f43.google.com with SMTP id z17so3393559wmi.1
        for <nvdimm@lists.linux.dev>; Mon, 13 Jun 2022 10:54:52 -0700 (PDT)
X-Received: by 2002:a1c:5418:0:b0:39c:3552:c85e with SMTP id
 i24-20020a1c5418000000b0039c3552c85emr16162741wmb.68.1655142892217; Mon, 13
 Jun 2022 10:54:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <YqaAcKsd6uGfIQzM@zeniv-ca.linux.org.uk>
In-Reply-To: <YqaAcKsd6uGfIQzM@zeniv-ca.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 13 Jun 2022 10:54:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjmCzdNDCt6L8-N33WSRaYjnj0=yTc_JG8A_Pd7ZEtEJw@mail.gmail.com>
Message-ID: <CAHk-=wjmCzdNDCt6L8-N33WSRaYjnj0=yTc_JG8A_Pd7ZEtEJw@mail.gmail.com>
Subject: Re: [RFC][PATCH] fix short copy handling in copy_mc_pipe_to_iter()
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Sun, Jun 12, 2022 at 5:10 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Unlike other copying operations on ITER_PIPE, copy_mc_to_iter() can
> result in a short copy.  In that case we need to trim the unused
> buffers, as well as the length of partially filled one - it's not
> enough to set ->head, ->iov_offset and ->count to reflect how
> much had we copied.  Not hard to fix, fortunately...
>
> I'd put a helper (pipe_discard_from(pipe, head)) into pipe_fs_i.h,
> rather than iov_iter.c -

Actually, since this "copy_mc_xyz()" stuff is going to be entirely
impossible to debug and replicate for any normal situation, I would
suggest we take the approach that we (long ago) used to take with
copy_from_user(): zero out the destination buffer, so that developers
that can't test the faulting behavior don't have to worry about it.

And then the existing code is fine: it will break out of the loop, but
it won't do the odd revert games and the "randomnoise.len -= rem"
thing that I can't wrap my head around.

Hmm?

                Linus
