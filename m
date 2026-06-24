Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2569A263C8C
	for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 04:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782276696; cv=none; b=MxVVAiehhkOpXDWBOFYCe6Wo0nw21pg/Jkv28bH65EXcoFkbFdkQrWtDVyTwjmDxf0DyAnJo5kTHzfyaud+3F155D1fk7Hni//Pwzdx7Y8ta/LCzCHGFGW8jQpPyAvdelju6rpa3LTOfLPW3K7ykQk5vInMswkgQBsGjEwGXShA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782276696; c=relaxed/simple;
	bh=h4+WD6wGYCjtiMKMjhA5oE5Aky55y5CGv2aQ1EEGdZo=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JWSiCTRR+0iiRQyVUTakRahsJBOJWVcgerTUfPyCumGsnxVAjd9rBDcOsFj9HJ971XcICJpljSi2daakvZWQULVGO9Pxo7KXLf5yYNmlNvOdih2k6idCrvbgYVCHoYjXOCvpZQk/m7Uf0QSnNZ5nLMtGf2Lva/1a1XCCIMBJazg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mo6AnHE7; arc=none smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mo6AnHE7"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-30b9e755555so1271673eec.1
        for <nvdimm@lists.linux.dev>; Tue, 23 Jun 2026 21:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782276694; x=1782881494; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/tl5h3JzKy69jcgHZtLXZFIs1eQB5U8ENwQAMJXVFE4=;
        b=Mo6AnHE72lxkM6lmseNxgwKCq72ZP2CZGtV+U0nkb3LihlNS3kZye4RD/dgm6JDMRP
         VZ9ZUMwLsr90Gq0OxXk6aQjlBiFFf4Jn76QgmEZOMeafhmf3fasnyQg+vwnWV2RRXOQP
         xccsYi+AceqP9I6NAFRnQcDo8H3c15BiFcdHub/40QUEzNsLbTm1gqbasu5Usin/YYyt
         70WnbdYEzrjsKwOzWoLo7zfXWTMHyRO9T/OP/EzqFn+Vq/A6fruFzMno40jO+4tCZCb7
         Tk6Yw10W4B8Nz4hYbciz3D+JaGdqBZ2Gkf0/8z4ALrbliB9dazxhrmPooTbgU5Oz6kuu
         udKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782276694; x=1782881494;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/tl5h3JzKy69jcgHZtLXZFIs1eQB5U8ENwQAMJXVFE4=;
        b=nZ9mCo/nthJJeSSLNW/ypwCAHlOO3Ne9AyfOAqI/vze9iF83w+eQQPuxkH4tehT7tg
         ObTZ01qAULrMAMKeBg74gZGBU2iJ0M8A9JD/ehNkUEL6MFfZ9eEXN/drbSlu5x/KU0Lv
         LEbefuX8ALBqUvXu0I1V9ESyT+TQCGwQ1whRcChqI7x4NJaJSnoVF0BPPmvwXkPlBeNY
         aEd5eF3FZecyTKnz/JkWaoV5VmedkW53v05BzBUHu7defE2tmVLntscF1T3I7vjBPyTc
         PWpSy9tejPlQ5+4ECYqf2o8PbbYxZwFj/cMtcspYilruEp4zWuetdthvF+CcasfYTjyQ
         e+/Q==
X-Forwarded-Encrypted: i=1; AHgh+RquVJ1mM9RotHxRMcTwEh46/glqjX2ENkmbr3mVx5F6A/H3b/FYMMtvW4Pk9Hl7iRdv5Q+lQ9o=@lists.linux.dev
X-Gm-Message-State: AOJu0YyidDXGEmRIvJGRKvjfHEQvOWebISupsS9S5D1BRunfjvRzed68
	qTeKOayLPEaeCww7O5ti1rNNmbe8GtnAkuB647AyWszqTaXIz1T1/Rce
X-Gm-Gg: AfdE7ckdKPr8G/qUQiBFSitGM2awjlWRPQahTc5dCUUDmFP0Y0cmHYy+3DUw2ilo3t4
	EV+lZNbPxUzb1MxOhLPbmtaUyLZGHX6Q+JJXjJw5sbBXfrArNZ0zGy2hrsIgogE0J21HVQ7NDwO
	Q0N7Bqhbhbm/jSDQZQfkA5btT7YLia9jDaS4s+Z/wtT+yspWq+O+PFgyHfuaa1Qnm2ydY7ExHw9
	BaQTLt8YEsFC7v/bHNkVPs4ttn6v8aNgKZTfylU/gytvb+4x1HWwR8mkm/AIHfAQNCblHjZxTMu
	H7e3LOodeHWv4XBzq6X2K7SDUslBBO+j5ThxBts3+EKem495L5Iv3lbjzXDS4bfdg5MrRrv4RGd
	+JO76J4iQPwCEvOZWR6MeLcJGw663wGM1mBLD2cnZ/xMmAXbVp8HsAeulSBqggVzuBlsNgNa/Qh
	dfJE+/L7XSEPvHSItJ1o++9r/drbjWvnB744Uh2HZxy80tIa2nHzXSHJWM5Q6Wqbdu6OzDt1qn1
	5SrvV4=
X-Received: by 2002:a05:7300:d518:b0:2c5:b23e:48a6 with SMTP id 5a478bee46e88-30c68dc9192mr1967871eec.23.1782276694184;
        Tue, 23 Jun 2026 21:51:34 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c1bdffa83sm25860253eec.23.2026.06.23.21.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 21:51:33 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Tue, 23 Jun 2026 21:51:31 -0700
To: Alison Schofield <alison.schofield@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <iweiny@kernel.org>,
	John Groves <John@groves.net>, Gregory Price <gourry@gourry.net>
Subject: Re: [PATCH v6 0/7] ndctl: Dynamic Capacity additions for cxl-cli
Message-ID: <ajtiU92IWkvyQIgj@AnisaLaptop.localdomain>
References: <20260523095043.471098-1-anisa.su@samsung.com>
 <aiJh7vcs2u1fMDX4@aschofie-mobl2.lan>
 <ajJITxBewsUuQGzp@aschofie-mobl2.lan>
 <ajOHhP7hX8r2ptKC@AnisaLaptop.localdomain>
 <ajSPiWGP_AiwYi23@aschofie-mobl2.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajSPiWGP_AiwYi23@aschofie-mobl2.lan>

On Thu, Jun 18, 2026 at 05:38:33PM -0700, Alison Schofield wrote:
> On Wed, Jun 17, 2026 at 10:52:04PM -0700, Anisa Su wrote:
> > On Wed, Jun 17, 2026 at 12:10:07AM -0700, Alison Schofield wrote:
> > > On Thu, Jun 04, 2026 at 10:43:10PM -0700, Alison Schofield wrote:
> > > > On Sat, May 23, 2026 at 02:50:35AM -0700, Anisa Su wrote:
> > > > > CXL Dynamic Capacity Device (DCD) support has continued to evolve in the
> > > > > upstream kernel since Ira's v5 posting [1].  The kernel side has settled
> > > > > on a uuid-driven claim model for sparse DAX devices: dax_resources carry
> > > > > the tag delivered with each extent, and userspace selects which ones to
> > > > > claim by writing a UUID to the dax device's sysfs 'uuid' attribute (or
> > > > > "0" to claim a single untagged resource).  Size on a sparse region is
> > > > > determined by the claim, not requested up-front.
> > > > > 
> > > > > This series brings cxl-cli and daxctl in line with that model and
> > > > > extends cxl_test to exercise the new paths end-to-end.
> > > > 
> > > > Hi Anisa,
> > > > 
> > > > I just now picked this up with the kernel side and took it for a quick
> > > > test drive. Based on what's been touched, first meaningful finding is
> > > > all the DAX unit tests pass, and then for CXL unit tests, all but these
> > > > 2 pass: cxl-security.sh and cxl-dcd.sh
> > > > 
> > > > Please let me know if there are known problems with either of those
> > > > before I explore further.
> > > 
> > > Hi Anisa,
> > > 
> > > Good news, DCD exposed a long hidden bug that made cxl-security.sh
> > > fail. It is not an issue w DCD patches.
> > > 
> > > Found that DCD set changes which mock memdev the test happens to
> > > land on, and that's enough to uncover a latent hex/decimal bug in
> > > CXL nvdimm code. We use to always land on id '1', but now this patch:
> > > 
> > > tools/testing/cxl: Add DC Regions to mock mem data
> > > 
> > > reorders the sorted dimm list, so the test selects a dimm with
> > > serial 10 (0xa), and there's the hex/decimal mismatch.
> > > 
> > > The renumbering is harmless in itself but it just changed the
> > > serial the test exercises and tripped over the old bug.
> > > 
> > > I'll send a separate fixup patch for the hex/dec cleanup.
> > > 
> > > (No answer on cxl-dcd.sh yet)
> > > 
> > > -- Alison
> > > 
> > Thanks for looking into this! I can also look into what might be going
> > on with cxl-dcd.sh if you let me know the base commit you applied the
> > dcd patches onto? :)
> 
> The base commit was indeed the key to the cxl-dcd.sh failure.
> 
> I'm seeing a probe-ordering race that you may not see unless you're
> using v7.1-rc1 or later. The branch linked in the kernel patchset does
> not include this commit -
> 
> 39aa1d4be12b ("dax/cxl, hmem: Initialize hmem early and defer dax_cxl binding")
> 
> Dan changed cxl_dax_region to PROBE_PREFER_ASYNCHRONOUS in support the
> DAX and HMEM synchronization, so I'm guessing that undoing that, is
> not an option. Before that change, cxl_dax_region probed synchronously
> and created the zero-sized seed dax device before cxlr_add_existing_extents()
> ran, so no race existed.
> 
> Move to 7.1 and you *should* see cxl-dcd.sh start failing. Since it's a
> timing issue, so you may need to dial down any dynamic debug and do
> repeated runs.
> 
> The race is on the dax_region device's devres_head between-
> (a) the asynchronous cxl_dax_region probe reaching really_probe()
> and
> (b) cxlr_add_existing_extents() attaching devres to the same device
> 
> really_probe() rejects probing devices that already have resources
> attached. If (b) wins, probe fails with -EBUSY, cxl_dax_region never
> binds, and the seed dax device is never created.
> 
> One possible fixup would be to move existing-extent processing into
> cxl_dax_region_probe() so that the resource attachment happens
> within the probe itself. That looked like more restructuring than I
> could quickly test out, so I'm sending it back to you.
> 
> Below is a reproducer using cxl_test and cxl-cli. It creates a DC region
> and checks immediately if its dax_region driver bound and a seed dax
> device exists. An 'unbound' dax_region is the bug.
> 
>     #!/bin/bash
>     set -u
>     CXL=${CXL:-cxl}; NDCTL=${NDCTL:-ndctl}; TRIALS=${1:-10}
>     bound=0 unbound=0
>     for t in $(seq 1 "$TRIALS"); do
>         $NDCTL disable-region -b cxl_test all >/dev/null 2>&1
>         modprobe -r cxl_test 2>/dev/null; modprobe cxl_test
>         udevadm settle 2>/dev/null; dmesg -C 2>/dev/null
>         # first non-sharable memdev with a dynamic_ram_a partition
>         # (serial 56540 == 0xDCDC is the mock's sharable fixture)
>         mem=$($CXL list -b cxl_test -Mi \
>             | jq -r '.[] | select(.dynamic_ram_a_size != null)
>                           | select(.serial != 56540) | .memdev' | head -1)
>         reg=$($CXL create-region -t dynamic_ram_a -d decoder0.0 -m "$mem" \
>             2>/dev/null | jq -r .region)
>         rnum=${reg#region}
>         # sample immediately, no sleep (what the test does via daxctl)
>         daxreg=$(readlink -f /sys/bus/cxl/devices/"$reg"/dax_region"$rnum" 2>/dev/null)
>         drv=$([ -e "$daxreg/driver" ] && echo bound || echo UNBOUND)
>         seed=$([ -e /sys/bus/dax/devices/dax"$rnum".0/uuid ] && echo yes || echo NO)
>         ebusy=$(dmesg 2>/dev/null | grep -c "Resources present before probing")
>         printf 'trial %2d: %s drv=%-7s seed=%-3s ebusy_msgs=%s\n' \
>             "$t" "$reg" "$drv" "$seed" "$ebusy"
>         [ "$drv" = bound ] && bound=$((bound+1)) || unbound=$((unbound+1))
>     done
>     echo "SUMMARY: bound=$bound unbound(FAIL)=$unbound of $TRIALS"
>     [ "$unbound" -eq 0 ] || exit 1
> 
> Sample output on a failing kernel-
>     trial  1: region9 drv=bound   seed=yes ebusy_msgs=0
>     trial  2: region9 drv=UNBOUND seed=NO  ebusy_msgs=1
>     trial  3: region9 drv=bound   seed=yes ebusy_msgs=0
>     trial  4: region9 drv=UNBOUND seed=NO  ebusy_msgs=1
>     ...
>     SUMMARY: bound=4 unbound(FAIL)=4 of 8
> 
Thank you so much for investigating. The fix you suggested works: I
moved the processing of existing extents to cxl_dax_region_probe().

This solved the probe-race, but it deadlocked because after processing existing
extents:
cxlr_notify_extent() does guard(device)(dev) on &cxlr->cxlr_dax->dev.
That lock is already held by probe.

To fix:
cxlr_notify_extent() split into core __cxlr_notify_extent() and wrapper
cxlr_notify_extent().

__cxlr_notify_extent() asserts device_lock_assert(dev) instead of
acquiring the lock. Call this directly in the process existing extents
path to skip trying to acquire lock again.

cxlr_notify_extent() wrapper acquires the lock for the other case --
extents added after driver loaded.

Thanks again for the thorough investigation! It was super helpful :)
- Anisa

> > 
> > Thanks,
> > Anisa
> > 
> 
> snip
> 
