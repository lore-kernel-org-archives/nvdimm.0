Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A563FC0
	for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 19:02:15 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id q21so1738451plq.3
        for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 12:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vq24WZbvZaeS/j6ldFMsVI1j+zKK5/FPuVsdEfF/56k=;
        b=TOwz77agxsX/Z6vHOfh3RsJJK/W+1zHnCyvXzIPPHH0ETLgijhzZ2KHfvVbfuBZXUU
         W7RxLzFOomU+omO1e7IJYkHSpOfBocIITKkP0hoCz7hrwaeTv/tHtIBs6v3Qm1cEeE3s
         BYWjlByN+DL2fqSBW2lTF4DMrC4azMiQx3p9eHngsI1+Y3jv87+8I3LNkxBTXJjANr30
         7CEN4njK3Ii27U1oagG8VmxC/Istn9iIJA2ak6hRDgtGP9+kbeGZMFxY8r8X94jb6OyD
         b+D1ylmnZf9dGOEPKHqAEyi5YLYmwJwKoN8RwMIlZbI80xPi4ZwIXBDd+RneAdyVTz/1
         hQlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vq24WZbvZaeS/j6ldFMsVI1j+zKK5/FPuVsdEfF/56k=;
        b=Jm2RVW8goZkeguBDkF8lEXVy/xHDMCMCbZbkJp2XFoeG68uXnHYcZr1H4LXmh4VWkB
         StgFS3mi7VVMhmgj9P19Ocbtsrhnp1K4V9Ah3s2wYCobEMNG0POQypDfbCNLPmi3r6TF
         mApLvnwmeFFniQLhNkhk6daY5IFGlyau5q/7h7RS6J6IzFHVyHMXBbTKNU2wY+HIULPh
         EAOBMBDWajM7Lu6lVSIUnsDeWaQ2tHomfeJ5w6m4hHzWauXSwKBp/JbMBNXl/6Q+YwTN
         FbOPyU3hemV+hBrHlJcGK0m0rvG/Ut2KllNhhXMMyQMO/FMd1Dfx7iuYTxUiqnUSQK05
         CL5w==
X-Gm-Message-State: AOAM530EBd5p5v+aC2uzchRspUTw9ToVlexgNuIRYRP8ySPhwTpCMvuw
	hv9suv1UBBYzFlqQ8DxKpDpybRZ6dmm8Fd2sO4p5Gw==
X-Google-Smtp-Source: ABdhPJw4ffFVirjni1kbtamzxeZlOeZAU2Wfrl9BJ1rGaHZkFmiEzD+T7HoyhzHN8ZFTf8oDeKzbEe1A35lBSTzbMnU=
X-Received: by 2002:a17:902:9b95:b0:130:6a7b:4570 with SMTP id
 y21-20020a1709029b9500b001306a7b4570mr18038564plp.27.1629745334855; Mon, 23
 Aug 2021 12:02:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210823123516.969486-1-hch@lst.de> <20210823123516.969486-4-hch@lst.de>
In-Reply-To: <20210823123516.969486-4-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 23 Aug 2021 12:02:04 -0700
Message-ID: <CAPcyv4ifoEi3E65yb3OOwwiY2aMyrSap=e7PohN-5w_K4RgKrg@mail.gmail.com>
Subject: Re: [PATCH 3/9] dm: use fs_dax_get_by_bdev instead of dax_get_by_host
To: Christoph Hellwig <hch@lst.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	linux-xfs <linux-xfs@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Aug 23, 2021 at 5:39 AM Christoph Hellwig <hch@lst.de> wrote:
>
> There is no point in trying to finding the dax device if the DAX flag is
> not set on the queue as none of the users of the device mapper exported
> block devices could make use of the DAX capability.

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
