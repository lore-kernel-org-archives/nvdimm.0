Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA22151990
	for <nvdimm@lists.linux.dev>; Mon, 23 Jun 2025 04:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750652308; cv=none; b=NgTV+IWGoH4GCHBmDCcNGqmpuxoaWuTkjQpMc3O6AIT0dDKDfd/WkWUh+WkBD89RN8C+s36IUSeHUj9O4+R12zPbEwxcPIdUol/QOeRvuJj7iBvKhpmd2NPVU07/7fwQmUZewnXwRTSEssH6RP3T5cDqucmftsqSPIRSV2PR/qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750652308; c=relaxed/simple;
	bh=LNvTQMohQGbCf669BPvM7Gt/ksdDI8Rt23bDew9iG48=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:From:To:Cc:
	 References:In-Reply-To; b=MT5umrMrJMGdt8T1ohU2UvOOUj3xNYTZsBRfq7SrdcsBFuQJAaFrHMYjAzIICIVajowDJUK626HSF7lSzC686XFEiulH0K3/zItWx4LXPePGZZdYDAtYiUN1h0oTf6gmCrJlSIemBUZ2h4NPqIa9rABDORntdCZYAEj7uLs7FoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cd0y3YNl; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cd0y3YNl"
Content-Type: multipart/mixed; boundary="------------Xeu1yh6QyigQDsRmSTUjsv3o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750652294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1a6j6ymdbum7p7MsHk6NCF4o6R+uaO7oENryoGusN1c=;
	b=cd0y3YNlQeQtBV0/CejXJE54HeIGC/QP8qxcQioeKpKXzgM0Oh9pHuEyG9IzT22bD721Yi
	5TUE40R1gznoPE88IlPT9C0IMCNXvAGip9YJQUaXH1SzsVu7v8dZGhiERDffMWhUXUtms3
	Lym/f5EF4E9sJQZjcQ0hXk8C1UmU5c8=
Message-ID: <9dd017ea-a0ec-47c4-b7ae-b6f441dbd5ec@linux.dev>
Date: Mon, 23 Jun 2025 12:18:08 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: =?UTF-8?Q?Re=3A_=5BRFC_v2_00/11=5D_dm-pcache_=E2=80=93_persistent-m?=
 =?UTF-8?Q?emory_cache_for_block_devices?=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk, hch@lst.de,
 dan.j.williams@intel.com, Jonathan.Cameron@Huawei.com,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, dm-devel@lists.linux.dev
References: <20250605142306.1930831-1-dongsheng.yang@linux.dev>
 <dc019764-5128-526e-d8ea-effa78e37b39@redhat.com>
 <3c9f304a-b830-4242-8e01-04efab4e0eaa@linux.dev>
In-Reply-To: <3c9f304a-b830-4242-8e01-04efab4e0eaa@linux.dev>
X-Migadu-Flow: FLOW_OUT

This is a multi-part message in MIME format.
--------------Xeu1yh6QyigQDsRmSTUjsv3o
Content-Type: multipart/alternative;
 boundary="------------aMux5mWrKV7NqLbSowDXImIu"

--------------aMux5mWrKV7NqLbSowDXImIu
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 6/23/2025 11:13 AM, Dongsheng Yang 写道:
>
> Hi Mikulas:
>
>      I will send dm-pcache V1 soon, below is my response to your comments.
>
> 在 6/13/2025 12:57 AM, Mikulas Patocka 写道:
>> Hi
>>
>>
>> On Thu, 5 Jun 2025, Dongsheng Yang wrote:
>>
>>> Hi Mikulas and all,
>>>
>>> This is *RFC v2* of the *pcache* series, a persistent-memory backed cache.
>>>
>>>
>>> ----------------------------------------------------------------------
>>> 1. pmem access layer
>>> ----------------------------------------------------------------------
>>>
>>> * All reads use *copy_mc_to_kernel()* so that uncorrectable media
>>>    errors are detected and reported.
>>> * All writes go through *memcpy_flushcache()* to guarantee durability
>>>    on real persistent memory.
>> You could also try to use normal write and clflushopt for big writes - I
>> found out that for larger regions it is better - see the function
>> memcpy_flushcache_optimized in dm-writecache. Test, which way is better.
>
> I did a test with fio on /dev/pmem0, with an attached patch on nd_pmem.ko:
>
> when I use memmap pmem device, I got a similar result with the comment 
> in memcpy_flushcache_optimized():
>
> Test (memmap pmem) clflushopt flushcache 
> ------------------------------------------------- test_randwrite_512 
> 200 MiB/s 228 MiB/s test_randwrite_1024 378 MiB/s 431 MiB/s 
> test_randwrite_2K 773 MiB/s 769 MiB/s test_randwrite_4K 1364 MiB/s 
> 1272 MiB/s test_randwrite_8K 2078 MiB/s 1817 MiB/s test_randwrite_16K 
> 2745 MiB/s 2098 MiB/s test_randwrite_32K 3232 MiB/s 2231 MiB/s 
> test_randwrite_64K 3660 MiB/s 2411 MiB/s test_randwrite_128K 3922 
> MiB/s 2513 MiB/s test_randwrite_1M 3824 MiB/s 2537 MiB/s 
> test_write_512 228 MiB/s 228 MiB/s test_write_1024 439 MiB/s 423 MiB/s 
> test_write_2K 841 MiB/s 800 MiB/s test_write_4K 1364 MiB/s 1308 MiB/s 
> test_write_8K 2107 MiB/s 1838 MiB/s test_write_16K 2752 MiB/s 2166 
> MiB/s test_write_32K 3213 MiB/s 2247 MiB/s test_write_64K 3661 MiB/s 
> 2415 MiB/s test_write_128K 3902 MiB/s 2514 MiB/s test_write_1M 3808 
> MiB/s 2529 MiB/s
>
> But I got a different result when I use Optane pmem100:
>
> Test (Optane pmem100) clflushopt flushcache 
> ------------------------------------------------- test_randwrite_512 
> 167 MiB/s 226 MiB/s test_randwrite_1024 301 MiB/s 420 MiB/s 
> test_randwrite_2K 615 MiB/s 639 MiB/s test_randwrite_4K 967 MiB/s 1024 
> MiB/s test_randwrite_8K 1047 MiB/s 1314 MiB/s test_randwrite_16K 1096 
> MiB/s 1377 MiB/s test_randwrite_32K 1155 MiB/s 1382 MiB/s 
> test_randwrite_64K 1184 MiB/s 1452 MiB/s test_randwrite_128K 1199 
> MiB/s 1488 MiB/s test_randwrite_1M 1178 MiB/s 1499 MiB/s 
> test_write_512 233 MiB/s 233 MiB/s test_write_1024 424 MiB/s 391 MiB/s 
> test_write_2K 706 MiB/s 760 MiB/s test_write_4K 978 MiB/s 1076 MiB/s 
> test_write_8K 1059 MiB/s 1296 MiB/s test_write_16K 1119 MiB/s 1380 
> MiB/s test_write_32K 1158 MiB/s 1387 MiB/s test_write_64K 1184 MiB/s 
> 1448 MiB/s test_write_128K 1198 MiB/s 1481 MiB/s test_write_1M 1178 
> MiB/s 1486 MiB/s
>
>
> So for now I’d rather keep using flushcache in pcache. In future, once 
> we’ve come up with a general-purpose optimization, we can switch to that.
>
Sorry for the formatting issue—the table can be checked in attachment 
<pmem_test_result>

Thanx

Dongsheng

--------------aMux5mWrKV7NqLbSowDXImIu
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">在 6/23/2025 11:13 AM, Dongsheng Yang
      写道:<br>
    </div>
    <blockquote type="cite"
      cite="mid:3c9f304a-b830-4242-8e01-04efab4e0eaa@linux.dev">
      <p>Hi Mikulas:</p>
      <p>     I will send dm-pcache V1 soon, below is my response to
        your comments.</p>
      <div class="moz-cite-prefix">在 6/13/2025 12:57 AM, Mikulas Patocka
        写道:<br>
      </div>
      <blockquote type="cite"
        cite="mid:dc019764-5128-526e-d8ea-effa78e37b39@redhat.com">
        <pre wrap="" class="moz-quote-pre">Hi


On Thu, 5 Jun 2025, Dongsheng Yang wrote:

</pre>
        <blockquote type="cite">
          <pre wrap="" class="moz-quote-pre">Hi Mikulas and all,

This is *RFC v2* of the *pcache* series, a persistent-memory backed cache.


----------------------------------------------------------------------
1. pmem access layer
----------------------------------------------------------------------

* All reads use *copy_mc_to_kernel()* so that uncorrectable media
  errors are detected and reported.
* All writes go through *memcpy_flushcache()* to guarantee durability
  on real persistent memory.
</pre>
        </blockquote>
        <pre wrap="" class="moz-quote-pre">You could also try to use normal write and clflushopt for big writes - I 
found out that for larger regions it is better - see the function 
memcpy_flushcache_optimized in dm-writecache. Test, which way is better.</pre>
      </blockquote>
      <p>I did a test with fio on /dev/pmem0, with an attached patch on
        nd_pmem.ko:</p>
      <p>when I use memmap pmem device, I got a similar result with the
        comment in <span>memcpy_flushcache_optimized():</span></p>
      <p><span>Test (memmap pmem) clflushopt flushcache
          -------------------------------------------------
          test_randwrite_512 200 MiB/s 228 MiB/s
          test_randwrite_1024 378 MiB/s 431 MiB/s
          test_randwrite_2K 773 MiB/s 769 MiB/s
          test_randwrite_4K 1364 MiB/s 1272 MiB/s
          test_randwrite_8K 2078 MiB/s 1817 MiB/s
          test_randwrite_16K 2745 MiB/s 2098 MiB/s
          test_randwrite_32K 3232 MiB/s 2231 MiB/s
          test_randwrite_64K 3660 MiB/s 2411 MiB/s
          test_randwrite_128K 3922 MiB/s 2513 MiB/s
          test_randwrite_1M 3824 MiB/s 2537 MiB/s
          test_write_512 228 MiB/s 228 MiB/s
          test_write_1024 439 MiB/s 423 MiB/s
          test_write_2K 841 MiB/s 800 MiB/s
          test_write_4K 1364 MiB/s 1308 MiB/s
          test_write_8K 2107 MiB/s 1838 MiB/s
          test_write_16K 2752 MiB/s 2166 MiB/s
          test_write_32K 3213 MiB/s 2247 MiB/s
          test_write_64K 3661 MiB/s 2415 MiB/s
          test_write_128K 3902 MiB/s 2514 MiB/s
          test_write_1M 3808 MiB/s 2529 MiB/s</span></p>
      <p><span>But I got a different result when I use Optane pmem100:</span></p>
      <p><span>Test (Optane pmem100) clflushopt flushcache
          -------------------------------------------------
          test_randwrite_512 167 MiB/s 226 MiB/s
          test_randwrite_1024 301 MiB/s 420 MiB/s
          test_randwrite_2K 615 MiB/s 639 MiB/s
          test_randwrite_4K 967 MiB/s 1024 MiB/s
          test_randwrite_8K 1047 MiB/s 1314 MiB/s
          test_randwrite_16K 1096 MiB/s 1377 MiB/s
          test_randwrite_32K 1155 MiB/s 1382 MiB/s
          test_randwrite_64K 1184 MiB/s 1452 MiB/s
          test_randwrite_128K 1199 MiB/s 1488 MiB/s
          test_randwrite_1M 1178 MiB/s 1499 MiB/s
          test_write_512 233 MiB/s 233 MiB/s
          test_write_1024 424 MiB/s 391 MiB/s
          test_write_2K 706 MiB/s 760 MiB/s
          test_write_4K 978 MiB/s 1076 MiB/s
          test_write_8K 1059 MiB/s 1296 MiB/s
          test_write_16K 1119 MiB/s 1380 MiB/s
          test_write_32K 1158 MiB/s 1387 MiB/s
          test_write_64K 1184 MiB/s 1448 MiB/s
          test_write_128K 1198 MiB/s 1481 MiB/s
          test_write_1M 1178 MiB/s 1486 MiB/s</span></p>
      <p><br>
      </p>
      <p>So for now I’d rather keep using flushcache in pcache. In
        future, once we’ve come up with a general-purpose optimization,
        we can switch to that.</p>
    </blockquote>
    <p>Sorry for the formatting issue—the table can be checked in
      attachment &lt;pmem_test_result&gt;</p>
    <p>Thanx</p>
    <p>Dongsheng</p>
    <p>    </p>
    <blockquote type="cite"
      cite="mid:3c9f304a-b830-4242-8e01-04efab4e0eaa@linux.dev">
      <p><span style="white-space: pre-wrap">
</span></p>
    </blockquote>
    <blockquote type="cite"
      cite="mid:3c9f304a-b830-4242-8e01-04efab4e0eaa@linux.dev">
      <blockquote type="cite"
        cite="mid:dc019764-5128-526e-d8ea-effa78e37b39@redhat.com"> </blockquote>
    </blockquote>
  </body>
</html>

--------------aMux5mWrKV7NqLbSowDXImIu--
--------------Xeu1yh6QyigQDsRmSTUjsv3o
Content-Type: text/plain; charset=UTF-8; name="pmem_test_result.txt"
Content-Disposition: attachment; filename="pmem_test_result.txt"
Content-Transfer-Encoding: base64

VGVzdCAobWVtbWFwIHBtZW0pICAgICAgICAgICAgICAgICAgICAgIGNsZmx1c2hvcHQgICBm
bHVzaGNhY2hlDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tDQp0ZXN0X3JhbmR3cml0ZV81MTIgICAgICAgICAgICAgMjAwIE1pQi9zICAgICAg
MjI4IE1pQi9zDQp0ZXN0X3JhbmR3cml0ZV8xMDI0ICAgICAgICAgICAgMzc4IE1pQi9zICAg
ICAgNDMxIE1pQi9zDQp0ZXN0X3JhbmR3cml0ZV8ySyAgICAgICAgICAgICAgNzczIE1pQi9z
ICAgICAgNzY5IE1pQi9zDQp0ZXN0X3JhbmR3cml0ZV80SyAgICAgICAgICAgICAxMzY0IE1p
Qi9zICAgICAxMjcyIE1pQi9zDQp0ZXN0X3JhbmR3cml0ZV84SyAgICAgICAgICAgICAyMDc4
IE1pQi9zICAgICAxODE3IE1pQi9zDQp0ZXN0X3JhbmR3cml0ZV8xNksgICAgICAgICAgICAy
NzQ1IE1pQi9zICAgICAyMDk4IE1pQi9zDQp0ZXN0X3JhbmR3cml0ZV8zMksgICAgICAgICAg
ICAzMjMyIE1pQi9zICAgICAyMjMxIE1pQi9zDQp0ZXN0X3JhbmR3cml0ZV82NEsgICAgICAg
ICAgICAzNjYwIE1pQi9zICAgICAyNDExIE1pQi9zDQp0ZXN0X3JhbmR3cml0ZV8xMjhLICAg
ICAgICAgICAzOTIyIE1pQi9zICAgICAyNTEzIE1pQi9zDQp0ZXN0X3JhbmR3cml0ZV8xTSAg
ICAgICAgICAgICAzODI0IE1pQi9zICAgICAyNTM3IE1pQi9zDQp0ZXN0X3dyaXRlXzUxMiAg
ICAgICAgICAgICAgICAgMjI4IE1pQi9zICAgICAgMjI4IE1pQi9zDQp0ZXN0X3dyaXRlXzEw
MjQgICAgICAgICAgICAgICAgNDM5IE1pQi9zICAgICAgNDIzIE1pQi9zDQp0ZXN0X3dyaXRl
XzJLICAgICAgICAgICAgICAgICAgODQxIE1pQi9zICAgICAgODAwIE1pQi9zDQp0ZXN0X3dy
aXRlXzRLICAgICAgICAgICAgICAgICAxMzY0IE1pQi9zICAgICAxMzA4IE1pQi9zDQp0ZXN0
X3dyaXRlXzhLICAgICAgICAgICAgICAgICAyMTA3IE1pQi9zICAgICAxODM4IE1pQi9zDQp0
ZXN0X3dyaXRlXzE2SyAgICAgICAgICAgICAgICAyNzUyIE1pQi9zICAgICAyMTY2IE1pQi9z
DQp0ZXN0X3dyaXRlXzMySyAgICAgICAgICAgICAgICAzMjEzIE1pQi9zICAgICAyMjQ3IE1p
Qi9zDQp0ZXN0X3dyaXRlXzY0SyAgICAgICAgICAgICAgICAzNjYxIE1pQi9zICAgICAyNDE1
IE1pQi9zDQp0ZXN0X3dyaXRlXzEyOEsgICAgICAgICAgICAgICAzOTAyIE1pQi9zICAgICAy
NTE0IE1pQi9zDQp0ZXN0X3dyaXRlXzFNICAgICAgICAgICAgICAgICAzODA4IE1pQi9zICAg
ICAyNTI5IE1pQi9zDQoNCg0KVGVzdCAoT3B0YW5lIHBtZW0xMDApICAgICAgICAgICAgICAg
ICAgICAgY2xmbHVzaG9wdCAgIGZsdXNoY2FjaGUNCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCnRlc3RfcmFuZHdyaXRlXzUxMiAgICAgICAg
ICAgICAxNjcgTWlCL3MgICAgICAyMjYgTWlCL3MNCnRlc3RfcmFuZHdyaXRlXzEwMjQgICAg
ICAgICAgICAzMDEgTWlCL3MgICAgICA0MjAgTWlCL3MNCnRlc3RfcmFuZHdyaXRlXzJLICAg
ICAgICAgICAgICA2MTUgTWlCL3MgICAgICA2MzkgTWlCL3MNCnRlc3RfcmFuZHdyaXRlXzRL
ICAgICAgICAgICAgICA5NjcgTWlCL3MgICAgIDEwMjQgTWlCL3MNCnRlc3RfcmFuZHdyaXRl
XzhLICAgICAgICAgICAgIDEwNDcgTWlCL3MgICAgIDEzMTQgTWlCL3MNCnRlc3RfcmFuZHdy
aXRlXzE2SyAgICAgICAgICAgIDEwOTYgTWlCL3MgICAgIDEzNzcgTWlCL3MNCnRlc3RfcmFu
ZHdyaXRlXzMySyAgICAgICAgICAgIDExNTUgTWlCL3MgICAgIDEzODIgTWlCL3MNCnRlc3Rf
cmFuZHdyaXRlXzY0SyAgICAgICAgICAgIDExODQgTWlCL3MgICAgIDE0NTIgTWlCL3MNCnRl
c3RfcmFuZHdyaXRlXzEyOEsgICAgICAgICAgIDExOTkgTWlCL3MgICAgIDE0ODggTWlCL3MN
CnRlc3RfcmFuZHdyaXRlXzFNICAgICAgICAgICAgIDExNzggTWlCL3MgICAgIDE0OTkgTWlC
L3MNCnRlc3Rfd3JpdGVfNTEyICAgICAgICAgICAgICAgICAyMzMgTWlCL3MgICAgICAyMzMg
TWlCL3MNCnRlc3Rfd3JpdGVfMTAyNCAgICAgICAgICAgICAgICA0MjQgTWlCL3MgICAgICAz
OTEgTWlCL3MNCnRlc3Rfd3JpdGVfMksgICAgICAgICAgICAgICAgICA3MDYgTWlCL3MgICAg
ICA3NjAgTWlCL3MNCnRlc3Rfd3JpdGVfNEsgICAgICAgICAgICAgICAgICA5NzggTWlCL3Mg
ICAgIDEwNzYgTWlCL3MNCnRlc3Rfd3JpdGVfOEsgICAgICAgICAgICAgICAgIDEwNTkgTWlC
L3MgICAgIDEyOTYgTWlCL3MNCnRlc3Rfd3JpdGVfMTZLICAgICAgICAgICAgICAgIDExMTkg
TWlCL3MgICAgIDEzODAgTWlCL3MNCnRlc3Rfd3JpdGVfMzJLICAgICAgICAgICAgICAgIDEx
NTggTWlCL3MgICAgIDEzODcgTWlCL3MNCnRlc3Rfd3JpdGVfNjRLICAgICAgICAgICAgICAg
IDExODQgTWlCL3MgICAgIDE0NDggTWlCL3MNCnRlc3Rfd3JpdGVfMTI4SyAgICAgICAgICAg
ICAgIDExOTggTWlCL3MgICAgIDE0ODEgTWlCL3MNCnRlc3Rfd3JpdGVfMU0gICAgICAgICAg
ICAgICAgIDExNzggTWlCL3MgICAgIDE0ODYgTWlCL3M=

--------------Xeu1yh6QyigQDsRmSTUjsv3o--
