Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5394C366
	for <nvdimm@lists.linux.dev>; Fri,  8 Apr 2022 06:26:19 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id s2so7577890pfh.6
        for <nvdimm@lists.linux.dev>; Thu, 07 Apr 2022 23:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=g35dmgX32k/R7TxnuKRf02cyb1nmI23wQu6jsuLVbVU=;
        b=wlSIBbbSFHb+JhPPPwZhYXbD7WTAYzJ9ooeCOJ4TJorGTR9S6YbwY6kt+RuyigO524
         kMvXQrASEbH6rcmScjaHvcogjfqkb8NJlfaBW2HLpnN56HWsI5uwggQ+dYV/aoIepw/E
         nURCc8MnNjmA0kvJ5xVOTCAndDTK2kjR54OW2WJBfuINbnBPEn1OXIKcmO1sLyaob2Ed
         9WV7jQkkHpFjZGrAf5cVdT00/H55NyENNDR9ohZpO6Hq09QYEVUxnOtII9fZ0Q0VRD+x
         sv0Gji5mFmzwSVQRwIxHosZoXz1DCVg7lzTFeipG8MZ1kmYnGngZUkUnKri1pi1o27UQ
         FLEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=g35dmgX32k/R7TxnuKRf02cyb1nmI23wQu6jsuLVbVU=;
        b=UzC0n1kNaiR6zdrCrCld74hOHe486iguSQN7iBXlepV9fxSTF4Ni+2zmwiXTsT6zbX
         L5+9gMbGKKFzSx0R0jRg9ooQxyUn06fPf1szXYPfjmJbmj3OIoDuAuKuf0TmTqKxQQeL
         TSUo+3qD3j3ihTBQ2IfCcRzzBcCckfLR/ZrWO8F0mrKJcvtpqX6qnMOku9kIgDQO6FFd
         8K58ouANHxNxiYwaNnVYaev0I3NnmtXaCJyoQVR7z+/6IVeCuNw04sKls/CLYd2WyUXM
         +YKL9Jd9E8hSYEkTmBglnPYnbLQpmywFxMKXSg7ZEfmW5+4rX5QE81FzLYSoy6HY1Qs3
         JVOQ==
X-Gm-Message-State: AOAM533ZR2jtnhbGUml2Cj2dN1YNrkGgfbwNrl2cYi8brDoF4ROsZPfX
	78ShXgJHUz1RE4Pk9glurUQBDH7eD5ZIO5B99nC8iw==
X-Google-Smtp-Source: ABdhPJwZpPAQGEBsOe2H4Ew1tYOWqLCmIf5LQhtcpsvQh/Ztm9JTK+n38+TDSeB0NMkBLck/NVWRLJvt/A/qt2vd7YI=
X-Received: by 2002:a05:6a00:8c5:b0:4fe:134d:30d3 with SMTP id
 s5-20020a056a0008c500b004fe134d30d3mr18016783pfu.3.1649399178836; Thu, 07 Apr
 2022 23:26:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220227120747.711169-1-ruansy.fnst@fujitsu.com>
 <20220227120747.711169-8-ruansy.fnst@fujitsu.com> <YkPyBQer+KRiregd@infradead.org>
 <8f1931d2-b224-de98-4593-df136f397eb4@fujitsu.com>
In-Reply-To: <8f1931d2-b224-de98-4593-df136f397eb4@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 7 Apr 2022 23:26:08 -0700
Message-ID: <CAPcyv4jO+-JkRcwZk0ZuYaGy0NDx2iZg-GjnDLWqVFYvciFF4g@mail.gmail.com>
Subject: Re: [PATCH v11 7/8] xfs: Implement ->notify_failure() for XFS
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	david <david@fromorbit.com>, Jane Chu <jane.chu@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 7, 2022 at 11:05 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrot=
e:
>
>
>
> =E5=9C=A8 2022/3/30 14:00, Christoph Hellwig =E5=86=99=E9=81=93:
> >> @@ -1892,6 +1893,8 @@ xfs_free_buftarg(
> >>      list_lru_destroy(&btp->bt_lru);
> >>
> >>      blkdev_issue_flush(btp->bt_bdev);
> >> +    if (btp->bt_daxdev)
> >> +            dax_unregister_holder(btp->bt_daxdev, btp->bt_mount);
> >>      fs_put_dax(btp->bt_daxdev);
> >>
> >>      kmem_free(btp);
> >> @@ -1939,6 +1942,7 @@ xfs_alloc_buftarg(
> >>      struct block_device     *bdev)
> >>   {
> >>      xfs_buftarg_t           *btp;
> >> +    int                     error;
> >>
> >>      btp =3D kmem_zalloc(sizeof(*btp), KM_NOFS);
> >>
> >> @@ -1946,6 +1950,14 @@ xfs_alloc_buftarg(
> >>      btp->bt_dev =3D  bdev->bd_dev;
> >>      btp->bt_bdev =3D bdev;
> >>      btp->bt_daxdev =3D fs_dax_get_by_bdev(bdev, &btp->bt_dax_part_off=
);
> >> +    if (btp->bt_daxdev) {
> >> +            error =3D dax_register_holder(btp->bt_daxdev, mp,
> >> +                            &xfs_dax_holder_operations);
> >> +            if (error) {
> >> +                    xfs_err(mp, "DAX device already in use?!");
> >> +                    goto error_free;
> >> +            }
> >> +    }
> >
> > It seems to me that just passing the holder and holder ops to
> > fs_dax_get_by_bdev and the holder to dax_unregister_holder would
> > significantly simply the interface here.
> >
> > Dan, what do you think?
>
> Hi Dan,
>
> Could you give some advise on this API?  Is it needed to move
> dax_register_holder's job into fs_dax_get_by_bdev()?


Yes, works for me to just add them as optional arguments.
