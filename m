Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821CB1E5702
	for <nvdimm@lists.linux.dev>; Mon, 30 Jun 2025 16:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751300907; cv=none; b=SGcw1cjvsQDBIdENqx2WPvyYoYYZ2a8p3uzq/tG6z1uuJUflnsjMMuRC33QaiJBpGadT4WsqWyMYNgckjidGnyaz/wCh8/FM9wHyzf99v+3wNI9zcoT8H3tD8SjzrF9Rye+UX1JAZv0hpslkRv8MMRoL8+QAuPZshR/Sj7YMUgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751300907; c=relaxed/simple;
	bh=kZz5sHMIEYQknhrJKSrbiWd5YuyAAbeWM7s7ko+r/GA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XFXJIyXqGN3y/xqzvAhJEkus0UWSZOgXLIyOHojNgDV/cGRK9fFpiU78wlBXXr9q7jLLw4C3BvzQnqBKJH6xJuoBrC8PmgexSnBzz2l2Ue3rNBSqmAia1ldqO6sNRNweruhyXLE9D0n839nrDOhQhwWu9bjaMk+RNd3f5B0TS4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uhEc38fE; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uhEc38fE"
Message-ID: <bf733634-cb99-48db-9b02-09b9700cd1f0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751300893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lO8fF4ZORcVnpss8t30+j+JORZPUFhEkRrsTLVwbWlk=;
	b=uhEc38fE1oedPOeKthtmO5ZaenunlM/yUS6Oy2FsJydoCnS5wdUne4Eejv4eW4uQBmBRSH
	0cd4Ffqtdi1fcFv2Q3SYquB6XlbjYb+RZQoSB53CQkE5GbLh3yKYOkk1d2pVYwzerAclVU
	WI+x25s4CDgdHYVLZVvwnXXd95nO96c=
Date: Tue, 1 Jul 2025 00:28:03 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: =?UTF-8?Q?Re=3A_=5BRFC_v2_00/11=5D_dm-pcache_=E2=80=93_persistent-m?=
 =?UTF-8?Q?emory_cache_for_block_devices?=
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk, hch@lst.de,
 dan.j.williams@intel.com, Jonathan.Cameron@Huawei.com,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, dm-devel@lists.linux.dev
References: <20250605142306.1930831-1-dongsheng.yang@linux.dev>
 <dc019764-5128-526e-d8ea-effa78e37b39@redhat.com>
 <3c9f304a-b830-4242-8e01-04efab4e0eaa@linux.dev>
 <202b7987-5652-ba46-2f9d-1a90679d89b5@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <202b7987-5652-ba46-2f9d-1a90679d89b5@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 6/30/2025 11:57 PM, Mikulas Patocka 写道:
>
> On Mon, 23 Jun 2025, Dongsheng Yang wrote:
>
>> +static int dm_pcache_map_bio(struct dm_target *ti, struct bio *bio)
>> +{
>> +     struct pcache_request *pcache_req = dm_per_bio_data(bio, sizeof(struct pcache_request));
>> +     struct dm_pcache *pcache = ti->private;
>> +     int ret;
>> +
>> +     pcache_req->pcache = pcache;
>> +     kref_init(&pcache_req->ref);
>> +     pcache_req->ret = 0;
>> +     pcache_req->bio = bio;
>> +     pcache_req->off = (u64)bio->bi_iter.bi_sector << SECTOR_SHIFT;
>> +     pcache_req->data_len = bio->bi_iter.bi_size;
>> +     INIT_LIST_HEAD(&pcache_req->list_node);
>> +     bio->bi_iter.bi_sector = dm_target_offset(ti, bio->bi_iter.bi_sector);
>>
>> This looks suspicious because you store the original bi_sector to
>> pcache_req->off and then subtract the target offset from it. Shouldn't
>> "bio->bi_iter.bi_sector = dm_target_offset(ti, bio->bi_iter.bi_sector);"
>> be before "pcache_req->off = (u64)bio->bi_iter.bi_sector <<
>> SECTOR_SHIFT;"?
>>
>>
>> Yes, that logic is indeed questionable, but it works in testing.
>>
>> Since we define dm-pcache as a **singleton**, both behaviors should
>> effectively be equivalent, IIUC. Also, in V1 I moved the call to
>> `dm_target_offset()` so it runs before setting up `pcache_req->off`,
>> making the code logic correct.
> If this target is singleton, you can delete the call to dm_target_offset
> at all.
>
> That call is harmless, but it looks confusing when reviewing the code,
> because pcache_req->off is set to the absolute bio sector (from the start
> of the table) and bio->bi_iter.bi_sector is set to the relative bio sector
> (from the start of the target). If the target always starts at offset 0,
> dm_target_offset just returns bi_sector.


That makes sense

Thanx

>
> Mikulas
>
