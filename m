Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF52E3AFD08;
	Thu, 10 Sep 2026 08:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789030707; cv=none; b=oi7ysXHcpwvT3GbqH+Idw7sIAnpwZoyqGn906wXJyPlz7mnU75RRjqmFRxPPjPfvo+eConxa2WesDWXR0kDmBg2EBtuDkX0JReGIHYPMv6gBVRAPMCrlrCxJlpngKGDNMFJgOJlWE6rh3EKnRT9Yhn2ZfZ2xZJ9t/zqaXzrrwNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789030707; c=relaxed/simple;
	bh=he5KiB6VLqYXxJgUJv16m3SCnnY9BNTeNN1ibGIWJqM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XqerZ7GShUykS21BTRJUw3NFS3kyB4EONMCjwDtCMMyM4/3Mc+GdZ4z1mpQc8fDj6CEAm/w/xhqEORCJKLZARWHRKwOAtnjsAFl4lL7ONplk52/iWek2YZUBMP73xGpEh460s4w4n/jN0x554KhG1Yecwyy9qwXket6zjxfjRyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MpUzMoWR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MpUzMoWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F9A1F000FF;
	Thu, 10 Sep 2026 08:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789030705;
	bh=MG/9KXk2jvCpvz70MN0ACXgz/x6FHQZmZN1K2kd/4gQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MpUzMoWRzc3w1dvHb0CKLDIJvfk81hBvJ+Ry3Z+tKkJ33lHiA4C3lJqJduoDoCZg9
	 goTs7zPI+AZIcnyDN+JDE8LQnV+mGfKRV4T7DqsNyTS9GLLTKG3YL8q4VaukX5vyNr
	 2Bdt5xG4J/Yp4QB3ushFrsyBjyEuFRxjMrzXErhETCfeTUi0Wst2Jtmc5CirLr/bar
	 FVhUeA0camPh5dX7vV9lPfJ79mNvls4s+q0bUM8P+Q7GyqdIpCADxOmPdHsPoBgMKd
	 0PPSkqz+JiLYrDRjsj0HyjbPQQE1nOrSub/adIftRor4yJB57BG447JjC0MsMN/ncm
	 LvpeJNdugcQEA==
Message-ID: <e2d2b01e-e6eb-4009-a07e-e615d576c0c3@kernel.org>
Date: Thu, 10 Sep 2026 10:58:05 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 14/36] mm/damon: skip private node memory in DAMON
 migration and pageout
To: Gregory Price <gourry@gourry.net>, SJ Park <sj@kernel.org>
Cc: arun.george@samsung.com, balbirs@nvidia.com, brendan.jackman@linux.dev,
 yuzenghui@huawei.com, apopple@nvidia.com, alucerop@amd.com,
 matthew.brost@intel.com, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org,
 gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
 djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
 alison.schofield@intel.com, osandov@osandov.com, jannh@google.com,
 pfalcato@suse.de, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 pbonzini@redhat.com, osalvador@suse.de, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
 kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk,
 longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org, mkoutny@suse.com,
 jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, lance.yang@linux.dev, usama.arif@linux.dev,
 xu.xin16@zte.com.cn, chengming.zhou@linux.dev, roman.gushchin@linux.dev,
 muchun.song@linux.dev, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, driver-core@lists.linux.dev,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 linux-debuggers@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 kvm@vger.kernel.org, cgroups@vger.kernel.org, damon@lists.linux.dev,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com
References: <amCzmkdOr6AFv_kQ@gourry-fedora-PF4VCD3F>
 <20260723001943.95854-1-sj@kernel.org>
 <amGHuputMNCFZ9CV@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <amGHuputMNCFZ9CV@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/23/26 05:25, Gregory Price wrote:
> On Wed, Jul 22, 2026 at 05:19:42PM -0700, SJ Park wrote:
>> On Wed, 22 Jul 2026 08:16:56 -0400 Gregory Price <gourry@gourry.net> wrote:
>>
>>>
>>> See the damon changes in:
>>>
>>> https://lore.kernel.org/linux-mm/al-pkvmgIxGu3LzM@gourry-fedora-PF4VCD3F/T/#mfb99303c85dd9d4c3f58832dc28fc55583a7217a
>>
>> Summarizing what you want to say, quoting something from the patch, or at least
>> calling it "26th patch of this series" would have made reviewing much easier.
>> Cc-ing damon@ for only patches that toucing DAMON source files and the cover
>> letter of the series could also be helpful.  Please consider doing some of
>> these for future replies.
>>
> 
> I have been very much discouraged from this kind of trimming because it
> removes the context of the series from the individual patches - making it
> even more confusing.

Yes, 99% of upstream maintainers will scream at you if you CC them only on
individual patches :)

-- 
Cheers,

David
