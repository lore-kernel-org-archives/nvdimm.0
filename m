Received: from mail1.bemta41.messagelabs.com (mail1.bemta41.messagelabs.com [195.245.230.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529B532D7FF
	for <nvdimm@lists.linux.dev>; Fri, 20 Feb 2026 09:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.245.230.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771580727; cv=none; b=mW/g/5HCy1aORFd3qqOL/CkPRSxQIsN/R4S2uuOEfvlYhcsMl/njkbiYu9M2vXg42hVMtDKZpxs+HmyHiNYUhUZ0oxkTmgXENyhjfZbOp1cVlFbrEkBTB4qOIAxmAy2qB8Oc2BdWkVAiotLtkSMY93rjE522ZQI8fcYUVnqcm5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771580727; c=relaxed/simple;
	bh=wJWfGk7BNqg3EveEUI889GcA2wUx2SpY7lRosAW9aBM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HlkY7EaKab9btm2JcI6V1wVTyaCBl4itBKTcK9aSxvWzed1VDe4APwrbrQ/rrdQ4ZUlMv+bnmpeYOdoQB78r5CCWWQGgxJZfs53XlzT+7WTqnBSOJIECiUCo9+egQ5Y/vHRqW43U+vIMMQYZzzmb7aH1iV1XY0DpJA8nwbuxhLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=FFFsn7vP; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=HhKqAT97; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=HhKqAT97; arc=none smtp.client-ip=195.245.230.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="FFFsn7vP";
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="HhKqAT97";
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="HhKqAT97"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
	s=170520fj; t=1771580723; i=@fujitsu.com;
	bh=jtIHzUFqVK9OPNLco4+7DqEQIozirk/DIYVzX5HTsD8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	b=FFFsn7vPE5ZlIHxMJVEAiiymF7QCALndmh4cBbbuk/ZUXRsLd5GA1vpMcZ7gf6FWQ
	 BqjaxUw93q9E5wzsES9j3ZaBVKR1NQPqc28HuWkLm83zbUwFry8srB9zQj36y3lnJp
	 Nog5C3JK8MBVLIFgXTbhbpnHZzUmG08s7mIP58jxisaH1B2WzX19sMcOxnl5eOR/+d
	 KefOp79f9HUm8r2fj390VathJamVjsxAdVnnGRi2Ri+gMssTWO2aPL5WnBH6bRaiPq
	 Z91oBEwvmbvqQrIaa92A2lZcxFqQVfkqZYmDmZD0tzEJoAHS6+J/F07uEv11juZP2Z
	 /4uAKHApRpnCw==
X-Brightmail-Tracker: H4sIAAAAAAAAA22Se0xbdRTH+d17e3vp6LxrR3ptxjCFoSIUEac
  /ooAmxt04iGbEscxks8CVNrYFe4sDphFWKzgyeax3QHnIYwOGZIyymbnAeNgBZcgzOKg8suE2
  YJlzFrchg3gLMmfifyfn8znfc/44BCr5EZcTTJqRMehVWgUuwiJfJ1TBocHFmhevDWyCU7NDO
  FxavAtgQcV9BLrOruKwiBsCsHciC4ffTTQCaKppwuFgyyMctt+4hcHSIhMCCy+MobCh6mccWi
  1tCBy09mGwtc2BwdGLZTh0HbMDaK64A2DODQ6Bpx8+EsCcu5ko7DnWgcDyRQ6FkydqAWxcvIf
  CX3oHBdCZ343A5Yf87CX7DPbGdvqB+RuMNo+s4PQP1ikh/aX9joBuqQ+ka1rnEdrW8DVOt5c3
  Cum5lhJAdyysAJor/YLur7QLaZdtO71c2g3e27xfoNHHJ6d9KFAPF85jKZV4muW6BckEFsFRI
  CIk5DlAXTU9wI8CTwIj36VOlg4AN8DI7zHq8s2Jf6xshDp3akiwYdnqhoT/Y5UDavz+itBt4W
  QINX68DLjrrWQg1ee4vTaBkhacWrp1Zm2hlDxA2euyeEDwUTuonvzd7raYjKSu5lWvKRTpS33
  LOQRuxZOMobKmY9xtCRlNFd/sxNf1LZSj5FfMXaO8bjpfiq6PBlBjAzY0H0itT2jWJ7RKgDQA
  yDKGTxlDcLgy3qBJUht1Ko1WqcoITlAyqYbkFCb4EMMaQ5VJCSlKhmWVbLouQZuo1DNGG+A/S
  fT7M7EXwLVVc0gXeJpAFN5i76BijWRzfHJiulrFqg8aUrUM2wW2EYSCEic+z7MtBiaJSftIo+
  X/cQNThJdiqzjkWR6L2RSVjtUkraM+EEY0T3e0ocS9ea4TlWD6ZD0jl4nPupNIt6pO1T8O2vj
  tEeAjl4qBh4eHxCuFMeg0xv/yBSAjgEIqvv0Cn+Kl0Rsf71vgT0H4Uz7Qce5TjKp/kTwTyQmo
  bY2LrXoqQOb3x+RypPO8eTL75Yw36/8q7I7I4xSfbJp5O2aOkvv17/0Kt5cV7Zz313/2WpXvO
  5HtLudoeeehQOlLdNjEjrBw37eauCOhrVcyKuoj4g+2+jhdEX9mB+1SSKN+8lQPGD5e6k/cn/
  b+lbrJrqby45dQbgr133Ym4nJd5pH+GW8Y4Fid2VVjPSEqFuwpEk2N7my2LY+VCT/PfS46vYC
  L9bFcDPd4BfwWnRe+z9S0+8B0b1xcxqvaWVk1eVJmHA49PF7rp8sd77HSMsSs7mzHSkKud5+W
  F8Bh/9zmw3RUddH0rJVuCYoamauXO/NNe8cdGT1j++Y1JQqMVatCA1EDq/obl6/DIlYEAAA=
X-Env-Sender: tomasz.wolski@fujitsu.com
X-Msg-Ref: server-10.tower-859.messagelabs.com!1771580720!48981!1
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received:
X-StarScan-Version: 9.121.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 31228 invoked from network); 20 Feb 2026 09:45:21 -0000
Received: from unknown (HELO n03ukasimr01.n03.fujitsu.local) (62.60.8.97)
  by server-10.tower-859.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 20 Feb 2026 09:45:21 -0000
Received: from n03ukasimr01.n03.fujitsu.local (localhost [127.0.0.1])
	by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTP id 720361009DA;
	Fri, 20 Feb 2026 09:45:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 n03ukasimr01.n03.fujitsu.local 720361009DA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
	s=dspueurope; t=1771580720;
	bh=jtIHzUFqVK9OPNLco4+7DqEQIozirk/DIYVzX5HTsD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HhKqAT97F6SM58cIkKGHj3KnNHeVT7YoH7Wv50EvuIhRjQ5M09RsWAu/RaFyx4LwP
	 +W/xgMssjygVwtA4NAM1iEkEKku966g3oHZNoRLty9Esr/dJpx3gvoUgFrF5rFxXy9
	 ViDOHhttoNbWUrhKNuRustiAydpmmUMef2KAt0ZjtHcxf2cHqyCoEam7Yh5d/5q0at
	 teyCaCg+5CYQySNKqaW/XTYEEV3lb4cZeSFiOE+qRx0wlYbZOEASz+Fv5UbXm3QBVs
	 pIhAdYwdwRoiQ/yExIgYRoMkiS+U/vERzQkCl/0CztQxLafHFlxnG1UdJ0iIpos1uN
	 HxPNOPCCbQQZw==
Received: from ubuntudhcp (unknown [10.172.107.4])
	(using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTPS id 4E6631009D9;
	Fri, 20 Feb 2026 09:45:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 n03ukasimr01.n03.fujitsu.local 4E6631009D9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
	s=dspueurope; t=1771580720;
	bh=jtIHzUFqVK9OPNLco4+7DqEQIozirk/DIYVzX5HTsD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HhKqAT97F6SM58cIkKGHj3KnNHeVT7YoH7Wv50EvuIhRjQ5M09RsWAu/RaFyx4LwP
	 +W/xgMssjygVwtA4NAM1iEkEKku966g3oHZNoRLty9Esr/dJpx3gvoUgFrF5rFxXy9
	 ViDOHhttoNbWUrhKNuRustiAydpmmUMef2KAt0ZjtHcxf2cHqyCoEam7Yh5d/5q0at
	 teyCaCg+5CYQySNKqaW/XTYEEV3lb4cZeSFiOE+qRx0wlYbZOEASz+Fv5UbXm3QBVs
	 pIhAdYwdwRoiQ/yExIgYRoMkiS+U/vERzQkCl/0CztQxLafHFlxnG1UdJ0iIpos1uN
	 HxPNOPCCbQQZw==
Received: from isar2.ecs00.fujitsu.local (unknown [10.172.183.27])
	by ubuntudhcp (Postfix) with ESMTP id D3CCD2204EA;
	Fri, 20 Feb 2026 09:45:19 +0000 (UTC)
From: Tomasz Wolski <tomasz.wolski@fujitsu.com>
To: smita.koralahallichannabasappa@amd.com
Cc: alison.schofield@intel.com,
	ardb@kernel.org,
	benjamin.cheatham@amd.com,
	bp@alien8.de,
	dan.j.williams@intel.com,
	dave.jiang@intel.com,
	dave@stgolabs.net,
	gregkh@linuxfoundation.org,
	huang.ying.caritas@gmail.com,
	ira.weiny@intel.com,
	jack@suse.cz,
	jeff.johnson@oss.qualcomm.com,
	jonathan.cameron@huawei.com,
	len.brown@intel.com,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	lizhijian@fujitsu.com,
	ming.li@zohomail.com,
	nathan.fontenot@amd.com,
	nvdimm@lists.linux.dev,
	pavel@kernel.org,
	peterz@infradead.org,
	rafael@kernel.org,
	rrichter@amd.com,
	terry.bowman@amd.com,
	tomasz.wolski@fujitsu.com,
	vishal.l.verma@intel.com,
	willy@infradead.org,
	yaoxt.fnst@fujitsu.com,
	yazen.ghannam@amd.com
Subject: Re: [PATCH v6 0/9] dax/hmem, cxl: Coordinate Soft Reserved handling with CXL and HMEM
Date: Fri, 20 Feb 2026 10:45:10 +0100
Message-Id: <20260220094510.17955-1-tomasz.wolski@fujitsu.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20260210064501.157591-1-Smita.KoralahalliChannabasappa@amd.com>
References: <20260210064501.157591-1-Smita.KoralahalliChannabasappa@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP

Tested on QEMU and physical setups. 

I have one question about "Soft Reserve" parent entries in iomem.
On QEMU I see parent "Soft Reserved":

a90000000-b4fffffff : Soft Reserved
  a90000000-b4fffffff : CXL Window 0
    a90000000-b4fffffff : dax1.0
      a90000000-b4fffffff : System RAM (kmem)

While on my physical setup this is missing - not sure if this is okay?

BIOS-e820: [mem 0x0000002070000000-0x000000a06fffffff] soft reserved

2070000000-606fffffff : CXL Window 0
  2070000000-606fffffff : region0
    2070000000-606fffffff : dax0.0
      2070000000-606fffffff : System RAM (kmem)
6070000000-a06fffffff : CXL Window 1
  6070000000-a06fffffff : region1
    6070000000-a06fffffff : dax1.0
      6070000000-a06fffffff : System RAM (kmem)

Tested-by: Tomasz Wolski <tomasz.wolski@fujitsu.com>
