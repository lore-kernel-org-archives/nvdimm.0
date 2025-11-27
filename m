Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A14530EF69;
	Thu, 27 Nov 2025 07:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764229229; cv=none; b=i78W8sEZhBc23nt1+YWFxGzD8VEGv2CpJtGTwCevinn86qoZ0LtWJKcHFCuL1GTwNKTC1/i7NbkUF08MeHXnZFGMhNLzyKVcqoXRlQApeDeQdVkzsLC3lC8ANsXvT08/IjaHEI/hK7X5kK59AMQuWeQVzDPqscZyXv914dlX6yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764229229; c=relaxed/simple;
	bh=v+x8m17SMep7QwNRc8L1NJ12+irfdLsoYz+Yneae5NA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gPMhLxbZQn0zxpphvNbNoKj9PvLf/P9G7kipi+5m4rgMcu0VytKobYeBunyBijwll6RFMXyH4QV/RM36a/0wTUfaxmQVHaBhYyB2Y+a78Kq0tQoHxyEPgBzpVVP4T38nq+gD6zLkxWZDzvaeH7X+V9CFMXRHKTBt5m6SWdWuJnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Nn9TcqxG; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Nn9TcqxG"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764229222; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=nZvOZnMAnx1zOEgYP1YGj2cerA28YaqBJ135PxGutMU=;
	b=Nn9TcqxGYPNdzPCUEb+xP6a86+VBpE6D7F72qYMMfL7NJMGj/MWBkmU6BDLOLfkMrKZdcJ/rNnrNqaGAx97iqNp8/B7J8ydksZK3CkNy6Smse2Ht/ZydHBGBYBATJha9jhT3xDapaX8lke4uICOolpl0AzxkuJvf4C1gawTuWao=
Received: from 30.221.131.208(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WtWMC3B_1764229221 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 27 Nov 2025 15:40:21 +0800
Message-ID: <3a29b0d8-f13d-4566-8643-18580a859af7@linux.alibaba.com>
Date: Thu, 27 Nov 2025 15:40:20 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Fix potential data loss and corruption due to Incorrect BIO Chain
 Handling
To: Christoph Hellwig <hch@infradead.org>,
 Stephen Zhang <starzhangzsd@gmail.com>
Cc: Ming Lei <ming.lei@redhat.com>, Andreas Gruenbacher
 <agruenba@redhat.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, nvdimm@lists.linux.dev,
 virtualization@lists.linux.dev, linux-nvme@lists.infradead.org,
 gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org,
 zhangshida@kylinos.cn
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
 <aSBA4xc9WgxkVIUh@infradead.org>
 <CANubcdVjXbKc88G6gzHAoJCwwxxHUYTzexqH+GaWAhEVrwr6Dg@mail.gmail.com>
 <aSP5svsQfFe8x8Fb@infradead.org>
 <CANubcdVgeov2fhcgDLwOmqW1BNDmD392havRRQ7Jz5P26+8HrQ@mail.gmail.com>
 <aSf6T6z6f2YqQRPH@infradead.org>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <aSf6T6z6f2YqQRPH@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Christoph,

On 2025/11/27 15:14, Christoph Hellwig wrote:
> On Thu, Nov 27, 2025 at 03:05:29PM +0800, Stephen Zhang wrote:
>> No, they are not using bcache.
> 
> Then please figure out how bio_chain_endio even gets called in this
> setup.  I think for mainline the approach should be to fix bcache
> and eorfs to not call into ->bi_end_io and add a BUG_ON() to

Just saw this.

For erofs, let me fix this directly to use bio_endio() instead
and go through the erofs (although it doesn't matter in practice
since no chain i/os for erofs and bio interfaces are unique and
friendly to operate bvecs for both block or non-block I/Os
compared to awkward bvec interfaces) and I will Cc you, Ming
and Stephen then.

Thanks,
Gao Xiang
