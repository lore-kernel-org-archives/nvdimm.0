Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D5F15573F
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 08:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749716839; cv=none; b=pBZDy8XBmtTbL3Z7sHHNo7iU4o1o3ENDNOnirbhvJq8SvBr3qnjus8l9MrcN1FdJg6Az/Vbfr8nWJB84+JMJcCWEx31p5xuxqK0TZd/rS3uDKaFLuubzuN/Khvm0cuND31afhKLpvcfmQz13IQvWN5GmUjlxOW3vd2kzSFwhq58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749716839; c=relaxed/simple;
	bh=hainky8gctJviguOl6nth/BkZnjuwyLykzKAN0GP39I=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=MDIO49WOucE53Zn7XJCmdYwH6fX9eDVdiya5sjji8X5TIukRuux0+I6QHzOdfyrSSfVH0RYlTowTXIK21grxKpYDlrLLgAeYpSq4ug4kzY01/TYdpVbAdV8Wz3qP1XPfwkluxY54lQ5qauXXrF06H3/vGrHMomSAfs0dsipKlqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UkJn1PHc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UkJn1PHc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749716836;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bN8Ot3+jNJZDy3gvrIb10O3K47lHJizLoV8n78vRwTE=;
	b=UkJn1PHcwHEdlhPCWzZH8GblQs7MoUc4Q59ol85mMxA0iO4ohf6fb/t6no0VNh9Zjvivm8
	7Nx0mwZHcbF7DDO6Pfnw4pJ2FuP7Wpy/dcspQhZDetfF3HKUUezIppHB1/0JS/vCGlm/Od
	EK/s7fgkXOXuIc6p3RePECO7FEX5gpk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-CAUND9llNjuWGYU34aAsXA-1; Thu, 12 Jun 2025 04:27:15 -0400
X-MC-Unique: CAUND9llNjuWGYU34aAsXA-1
X-Mimecast-MFC-AGG-ID: CAUND9llNjuWGYU34aAsXA_1749716834
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a523ce0bb2so362129f8f.0
        for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 01:27:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749716834; x=1750321634;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bN8Ot3+jNJZDy3gvrIb10O3K47lHJizLoV8n78vRwTE=;
        b=VitM3UXU66h2OD1hPjP+tsDVYA6Oy2kft+7gz+W4q3sVrOSR96FVGusVEr7AUgbpNV
         Wn2m82tyk7Q+IiPLNn0wJvhfAY4DYhE3nMAs5JAK4hc7ILVjVqENEs2lq8P/ByXycRCP
         8qTLYx57n7XyP6K7EPnXj4PpXN+4mg5enqc0SbGFhYMp7awnW9lOa/lenW7ln8KnZ4Xw
         eDp+IqkMrVkLQ85ZW6MxzLddjKR6CVFQk9jOGDXwZDgxvAN0CfumltuU2iiI1shXC3iY
         8pvcYuwJvPE17Z5X57N7Qu0SgFoYC/cKKMWMZroyaUXv5yWa6rrB0i0Q4mr0/Qud21UZ
         7vcg==
X-Forwarded-Encrypted: i=1; AJvYcCXtrjoJA/HglvZuVHr2u9SIlo5yfYQpuEi5G7SmQV8Ys244XIwLtz0xvqr2WsnZhV+pUwRkQMQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzNmC+FsZpxc8f/9ltYNtAM3cpgB9/3m2qwC0NaqobZRM0o3EEr
	ujOWEEogoiYhKxGnuUSyijAYynVT+6DxM13YeTlvXnkIfrOAsBYDta4N2mESBysxOeLKHXX0ZUt
	+OXmOySrUGzDaoiuTFnVO9KlIIknFwXz8BMvYFmiebZAGz+mAZdJxScMY9g==
X-Gm-Gg: ASbGncv4pXnhjILtNyomFBPWrUsA0yxtvIeFGwQoJuIhoATErzjgbvptbNIIFGxthlA
	BWdasyZcRbq7QMHEpiQatdq4BQHYxCSK/Pdy5jy6ySBpVrhPOgto00G8JtLGb1AdYPl7+XCDeoh
	6o6sAcO/gYHximfWvPFb+BDSi4Oay7Kirxbk7zuyP7OCzkQ6erpodC4MmKmLp5xAAqL1q+f24oe
	4eFwBkYpv8YQUkVs0WMOVEyTsn009aDxykBtxHaPnNmgEzVd+gImSIfQrNLINBvYlVJ/+fpteSt
	ZxLMnj6oaD+fvyYvBNHWwGn6m6Wvy2dqKB58mI9eu3poE/tciU8VZ4/XRIryLSnNlg9jPTWyUoQ
	TxPqy1qdpGS5hgrdvKuWcsL5GNUYd97AGW1Hi8F7smrDgn7pE/g==
X-Received: by 2002:a05:6000:4313:b0:3a4:f7e3:c63c with SMTP id ffacd0b85a97d-3a56126981bmr1748153f8f.0.1749716833835;
        Thu, 12 Jun 2025 01:27:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE5IaUy7ZOJxeKsAYaNcwddb/Oox2oCst9TiHvETD1rZWF9Q4Jcg1ZORYRbYQxMbsqDN9+G/w==
X-Received: by 2002:a05:6000:4313:b0:3a4:f7e3:c63c with SMTP id ffacd0b85a97d-3a56126981bmr1748125f8f.0.1749716833359;
        Thu, 12 Jun 2025 01:27:13 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2c:1e00:1e1e:7a32:e798:6457? (p200300d82f2c1e001e1e7a32e7986457.dip0.t-ipconnect.de. [2003:d8:2f2c:1e00:1e1e:7a32:e798:6457])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a561b4b79bsm1274569f8f.66.2025.06.12.01.27.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jun 2025 01:27:12 -0700 (PDT)
Message-ID: <e11ba418-4184-4f4f-add5-18a5edaa0f34@redhat.com>
Date: Thu, 12 Jun 2025 10:27:11 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] mm/huge_memory: vmf_insert_folio_*() and
 vmf_insert_pfn_pud() fixes
From: David Hildenbrand <david@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>,
 Alistair Popple <apopple@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Oscar Salvador <osalvador@suse.de>,
 marc.herbert@linux.intel.com
References: <20250611120654.545963-1-david@redhat.com>
 <lpfprux2x34qjgpuk6ufvuq4akzolt3gwn5t4hmfakxcqakgqy@ciiwnsoqsl6j>
 <684a5594eb21d_2491100de@dwillia2-xfh.jf.intel.com.notmuch>
 <990ce9cf-0e48-432c-a29f-0bd1704eede4@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <990ce9cf-0e48-432c-a29f-0bd1704eede4@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ij0s2_abTDUdH7XjYcYmO2uFVOc8wbvopMzB1FE1cnQ_1749716834
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12.06.25 09:18, David Hildenbrand wrote:
> On 12.06.25 06:20, Dan Williams wrote:
>> Alistair Popple wrote:
>>> On Wed, Jun 11, 2025 at 02:06:51PM +0200, David Hildenbrand wrote:
>>>> This is v2 of
>>>> 	"[PATCH v1 0/2] mm/huge_memory: don't mark refcounted pages special
>>>> 	 in vmf_insert_folio_*()"
>>>> Now with one additional fix, based on mm/mm-unstable.
>>>>
>>>> While working on improving vm_normal_page() and friends, I stumbled
>>>> over this issues: refcounted "normal" pages must not be marked
>>>> using pmd_special() / pud_special().
>>>>
>>>> Fortunately, so far there doesn't seem to be serious damage.
>>>>
>>>> I spent too much time trying to get the ndctl tests mentioned by Dan
>>>> running (.config tweaks, memmap= setup, ... ), without getting them to
>>>> pass even without these patches. Some SKIP, some FAIL, some sometimes
>>>> suddenly SKIP on first invocation, ... instructions unclear or the tests
>>>> are shaky. This is how far I got:
>>>
>>> FWIW I had a similar experience, although I eventually got the FAIL cases below
>>> to pass. I forget exactly what I needed to tweak for that though :-/
>>
>> Add Marc who has been working to clean the documentation up to solve the
>> reproducibility problem with standing up new environments to run these
>> tests.
> 
> I was about to send some doc improvements myself, but I didn't manage to
> get the tests running in the first place ... even after trying hard :)
> 
> I think there is also one issue with a test that requires you to
> actually install ndctl ... and some tests seem to temporarily fail with
> weird issues regarding "file size problems with /proc/kallsyms",
> whereby, ... there are no such file size problems :)
> 
> All a bit shaky. The "memmap=" stuff is not documented anywhere for the
> tests, which is required for some tests I think. Maybe it should be
> added, not sure how big of an area we actually need, though.
> 
>>
>> http://lore.kernel.org/20250521002640.1700283-1-marc.herbert@linux.intel.com
>>
> 
> I think I have CONFIG_XFS_FS=m (instead of y) and CONFIG_DAX=y (instead
> of =m), and CONFIG_NFIT_SECURITY_DEBUG not set (instead of =y).
> 
> Let me try with these settings adjusted.

Yeah, no. Unfortunately doesn't make it work with my debug config. Maybe with the
defconfig as raised by Marc it would do ... maybe will try that later.

# meson test -C build --suite ndctl:dax
ninja: Entering directory `/root/ndctl/build'
[1/70] Generating version.h with a custom command
  1/13 ndctl:dax / daxdev-errors.sh          OK              14.60s
  2/13 ndctl:dax / multi-dax.sh              OK               4.28s
  3/13 ndctl:dax / sub-section.sh            SKIP             0.25s   exit status 77
  4/13 ndctl:dax / dax-dev                   OK               1.00s
  5/13 ndctl:dax / dax-ext4.sh               OK              23.60s
  6/13 ndctl:dax / dax-xfs.sh                OK              23.74s
  7/13 ndctl:dax / device-dax                OK              40.61s
  8/13 ndctl:dax / revoke-devmem             OK               0.98s
  9/13 ndctl:dax / device-dax-fio.sh         SKIP             0.10s   exit status 77
10/13 ndctl:dax / daxctl-devices.sh         SKIP             0.16s   exit status 77
11/13 ndctl:dax / daxctl-create.sh          FAIL             2.53s   exit status 1
>>> DAXCTL=/root/ndctl/build/daxctl/daxctl DATA_PATH=/root/ndctl/test MSAN_OPTIONS=halt_on_error=1:abort_on_error=1:print_summary=1:print_stacktrace=1 MALLOC_PERTURB_=167 LD_LIBRARY_PATH=/root/ndctl/build/cxl/lib:/root/ndctl/build/daxctl/lib:/root/ndctl/build/ndctl/lib TEST_PATH=/root/ndctl/build/test UBSAN_OPTIONS=halt_on_error=1:abort_on_error=1:print_summary=1:print_stacktrace=1 NDCTL=/root/ndctl/build/ndctl/ndctl ASAN_OPTIONS=halt_on_error=1:abort_on_error=1:print_summary=1 /root/ndctl/test/daxctl-create.sh

12/13 ndctl:dax / dm.sh                     FAIL             0.24s   exit status 1
>>> DAXCTL=/root/ndctl/build/daxctl/daxctl DATA_PATH=/root/ndctl/test MSAN_OPTIONS=halt_on_error=1:abort_on_error=1:print_summary=1:print_stacktrace=1 UBSAN_OPTIONS=halt_on_error=1:abort_on_error=1:print_summary=1:print_stacktrace=1 LD_LIBRARY_PATH=/root/ndctl/build/cxl/lib:/root/ndctl/build/daxctl/lib:/root/ndctl/build/ndctl/lib TEST_PATH=/root/ndctl/build/test MALLOC_PERTURB_=27 NDCTL=/root/ndctl/build/ndctl/ndctl ASAN_OPTIONS=halt_on_error=1:abort_on_error=1:print_summary=1 /root/ndctl/test/dm.sh

13/13 ndctl:dax / mmap.sh                   OK             343.67s

Ok:                 8
Expected Fail:      0
Fail:               2
Unexpected Pass:    0
Skipped:            3
Timeout:            0

Full log written to /root/ndctl/build/meson-logs/testlog.txt


After compilation, I can see that I again have "CONFIG_DAX=y" in my config.

And for the DAX setting in "make menuconfig" I can see:

Symbol: DAX [=y]
  ...
  Selected by [y]:
  - FS_DAX [=y] && MMU [=y] && (ZONE_DEVICE [=y] || FS_DAX_LIMITED [=n]
  Selected by [m]:
  - BLK_DEV_PMEM [=m] && LIBNVDIMM [=m]

So I guess, as requested in the doc "CONFIG_FS_DAX=y" combined with
"CONFIG_DAX=m" is impossible to achieve?


===

sub-section.sh complains about

++ /root/ndctl/build/ndctl/ndctl list -R -b ACPI.NFIT
+ json=
++ echo
++ jq -r '[.[] | select(.available_size >= 67108864)][0].dev'
+ region=
++ echo
++ jq -r '[.[] | select(.available_size >= 67108864)][0].available_size'
+ avail=
+ '[' -z ']'
+ exit 77

Not sure what's the problem in my environment. I thought we would be emulating
ACPI.NFIT.

===

device-dax-fio.sh complains about

kernel 6.16.0-rc1-00069-g0ede5baa0b46: missing fio, skipping...

So I guess I just need to install "fio" to make it fly.

Yes, with that the test is passing now.

===

daxctl-devices.sh complains about

++ reset_dev
++ /root/ndctl/build/ndctl/ndctl destroy-namespace -f -b ACPI.NFIT 'Error at linn
e 33'
error destroying namespaces: No such device or address
destroyed 0 namespaces
++ exit 77


No idea.

===

daxctl-create.sh complains about

+ /root/ndctl/build/daxctl/daxctl reconfigure-device -m devdax -f dax1.0
libdaxctl: daxctl_dev_enable: dax1.0: failed to enable
error reconfiguring devices: Invalid argument
reconfigured 0 devices
++ cleanup 54
++ printf 'Error at line %d\n' 54
++ [[ -n dax1.0 ]]
++ reset_dax
++ test -n dax1.0
++ /root/ndctl/build/daxctl/daxctl disable-device -r 1 all
disabled 1 device
++ /root/ndctl/build/daxctl/daxctl destroy-device -r 1 all
destroyed 1 device
++ /root/ndctl/build/daxctl/daxctl reconfigure-device -s '' dax1.0
reconfigured 1 device
++ exit 1


Again, no idea ... :(


-- 
Cheers,

David / dhildenb

