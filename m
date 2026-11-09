Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794243791;
	b=ooeNz3GE5WIXVSCIQpb7FyyJqrf9eRjV4zqAR8m4CQPnxpRc/AyKknJbg8tgrfJ1cOcA
	 kKbzy8VmHx0D/xFN/DmyaDG8wA9SZPQpDgvhL0QK7/z2QtyQHya9FEbGO/NfhrqX3cof0
	 XDBalcUUvaqpnJkxKwcSxtOMSiR+EBKWmhqvdZhQwxHoode8SXcCmMsB34erTDXE+NK1i
	 GnLcdDVj60JSM9FtbLeg2Sj2+Y14wl8Ao+uKbHUnHJR/umrmCDLwqmLXGkL39wUwQCOLi
	 9O5gbyCFp2xeuoMm41DNWwHxAshcG8jztf02WrQS4xn6fFBO81Mzko8AkiTStO/JzLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794243791;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type;
	bh=EiCyFmyHns/6JeMiTgX99ZP7gU78wmi52w0Se9KfmH8=;
	b=xt9pBDllX6qZTv9DxVN0cZAGSEjLTYhZcEWD5/xV3z4IW7f4DbLUOoOSB4Pg2PG7SF4O
	 kgsvvK+QuLZanWX1fuD6VUT0ETiJYwnz7sV2WJRSAER6i0PSdLoezzxR1RkTVkbryXZLZ
	 6sGGqCBLCrf0p22drfec7w6scrQidbICic4fD55C91/T/jchDwAm4nkaBWFbtdOkd1tSz
	 n3aWgg0Li1ZoRy8gZtwuB/nNMqGNxPbhLHabSPZ7fEg0Hp2XI57j6U9xcuX1i4TPO01KV
	 IPJ1LnJXoDJ83CpwAB9G4m6sZbwRs/P+tkVoihD33frT0SsORUFRDk2awBw+YwUPopg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=QV0o9eMn;
	arc=none smtp.remote-ip=209.85.214.179
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F089606A325
	for <nvdimm@lists.linux.dev>; Mon,  9 Nov 2026 17:03:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F089606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=QV0o9eMn
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2e8d6fcbba0so52305ad.1
        for <nvdimm@lists.linux.dev>; Mon, 09 Nov 2026 09:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794243790; x=1794848590; darn=lists.linux.dev;
        h=content-type:mime-version:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EiCyFmyHns/6JeMiTgX99ZP7gU78wmi52w0Se9KfmH8=;
        b=QV0o9eMn+AgHT4UXjf4kZc767jNm346OkxDlgs3wI437szk5SpU4cMnYpsHDVWUKkr
         puf+q8iu4/4pz2U3lSI/Yckxq2RjDrJRVj4+hss/FOg74vDxg/XARg7nRgfaFFGWum3g
         ifiYxoRAPw57Lv8o2O9HT5vyS6YRGf8EjyKA7n53cs9ERphYo+EOF6fwzl2L+2/AkaEo
         Drb4cSO2a3M/zEjHV2vgo7g9vtbmPGdQfKY9TK5utinfoz7lEFJz43ETBTLeRWQ1Pbb6
         59TUey6/O6Ej11r89D/KCqi6q7L25nNDp++ExFadNevulG5rrF0PnNuB0fA+HPZgji+Z
         S7PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794243790; x=1794848590;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=EiCyFmyHns/6JeMiTgX99ZP7gU78wmi52w0Se9KfmH8=;
        b=h4ggU4HSW/wA1qn29HedAVaNKIp3W/oNLMz6gnYMgr3d9siu0f2U2Rh2LZgC7+VMSv
         tsSaYJObtZUko9SODWpE7FsjR7koLEPyWnCMUJX8Q9k6w3539jjS5pVhs/K4MjC4q0Og
         YlNKRXBw7wb84LAqYUvwh8h6p+pPjBvgsUdtSAjBNlD6n7zOYorbGovmMuaLDfVclB8s
         llhzpxpJMYvQdVYB3juEHDj8Jb4Seeew+6Oq2qb7JQQkSKNJODKTMTWw3qUg4Hj8NpbZ
         bQ3h5UnSfuGAhjVGZ7gvwbPQK3SdDUx9OWsQCWesLYg9akFoLE79BP3R7Hivs6PzruOV
         Yi8g==
X-Forwarded-Encrypted: i=1; AL+hErGO4ak9finX4iNSCajH9CUImz2ax8Jbg3Lc5yi2KkTH563hDxIqUsZ8LrXiI2sipaiMJjAeeQc=@lists.linux.dev
X-Gm-Message-State: APuU4Z8bot11Vf367oi5IXl9Ae/uJmzDDBiEcChvhIVgayS6WqY41pH/
	tKyJlq1Vnjrj80s3BW0E+tOS7qE9U/P84HBM/4nIrmFHIc5DPaP2jtWB7Ec4V1DVmg==
X-Gm-Gg: AYBFou1DupP94aVU2a2PJiO8k+45cnehwTJRkckJTp5KPPxubQn2lMo6bJ4NGZwUKiU
	qM3pOAXq/9+Vp9xWQcfyqi/Z/cZW3vswT+gvTggcm2+dFEbr/wzKrlSWr/b91JhyzHsLDzJ+s1S
	NhCdEQ0eOK0D+2I/VVkV1o9Wegt4yFZH3/nEVYw3EUldS4JIbRwgGtjySwfuErB3GXOaAc81Hfl
	bM187j6+CWIKKEthAbEez9HbAInO86ZEkVbuKv2OCjFe27ZsQsUCMBbwcfbHYVCPpSZCzOmDuFy
	tPdk3Ffq+MyWaNyVcPSQ+wVh2e8BPgTSv0p0ZEsxEmsWeyTZK2Ssul6i/Qz9ds1ztDo83KJws9Z
	FoH6KtwDye1CArO0HY6jzurGAjLizHb59S06mrWqdVUOC4sC1HS1h3IHirKAxCdm4h9Rd1I3Nok
	sbJVXrUi2ggGWx0JzmLDIvKkgFbaqZMchG1ARJIGtFBkWajjguKhXDNsoUPDvFXa7CiqdT5d1B0
	MwdlhRdCdHSdwsbivYOC84zpIbX8VYvBwl92ul4W9bb9lrTooChllch+38T0re62IyfwljtTW3C
	zqJundbFzW2lrWcck6UHkTxlZ9jcFjpuajRLIS//JDkXfKvDxOnJbOkMF3JvET4yCR2oj7hx73k
	g/TJM6swMrGQO62FtvRb8m33WrPof+aznlY7z0taV8QhBi1jYA/QBjWVJ91MyYgPshVzcI4d+xh
	vN5v2kcb1fSAqripfzYxEdNPZvBhb9MDgXjxN4WY/o0XVY
X-Received: by 2002:a17:902:cf0d:b0:2e7:e742:8bb5 with SMTP id d9443c01a7336-2edb6ef6dc6mr223335ad.14.1794243789717;
        Mon, 09 Nov 2026 09:03:09 -0800 (PST)
Received: from [2a00:79e0:2eb4:9:d9d8:521f:5a01:aae5] ([2a00:79e0:2eb4:9:d9d8:521f:5a01:aae5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b16769b589sm179496a91.5.2026.11.09.09.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 09:03:09 -0800 (PST)
Date: Mon, 9 Nov 2026 09:03:07 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Amit Shah <amit@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
    Aneesh Kumar <AneeshKumar.KizhakeVeetil@arm.com>, 
    Christoph Lameter <christoph@gentwo.org>, 
    Dave Hansen <dave.hansen@intel.com>, David Hildenbrand <david@kernel.org>, 
    Davidlohr Bueso <dave@stgolabs.net>, Harry Yoo <harry@kernel.org>, 
    Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
    John Hubbard <jhubbard@nvidia.com>, Jonathan Cameron <jic23@kernel.org>, 
    Joshua Hahn <joshua.hahnjy@gmail.com>, 
    Kirill Shutemov <k.shutemov@gmail.com>, 
    Matthew Wilcox <willy@infradead.org>, Mel Gorman <mel.gorman@gmail.com>, 
    Michal Hocko <mhocko@suse.com>, Mike Rapoport <mike.rapoport@gmail.com>, 
    Peter Xu <peterx@redhat.com>, Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, Rik van Riel <riel@surriel.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Shakeel Butt <shakeel.butt@linux.dev>, Shivank Garg <shivankg@amd.com>, 
    Sterling Alexander <stalexan@redhat.com>, 
    Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
    Vlastimil Babka <vbabka@kernel.org>, Yang Shi <shy828301@gmail.com>, 
    Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
    balbirs@nvidia.com, apopple@nvidia.com, matthew.brost@intel.com, 
    liam@infradead.org, alison.schofield@intel.com, osandov@osandov.com, 
    osalvador@suse.de, ying.huang@linux.alibaba.com, baohua@kernel.org, 
    tj@kernel.org, jgg@ziepe.ca, baolin.wang@linux.alibaba.com, 
    npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
    lance.yang@linux.dev, usama.arif@linux.dev, muchun.song@linux.dev
cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: [Invitation] Linux MM Alignment Session on Private Nodes and CRAM
 on Wednesday
Message-ID: <4b2a7250-ee0d-74ed-2301-ca2f8f30f850@google.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi everybody,

NOTE!!  Due to Daylight Savings Time ending, the time in your area may 
have changed.  Please see the list of times at the end of this email.

We host a biweekly series, the Linux MM Alignment Session, on Wednesdays.
We'd like to invite MM developers to attend and will announce the topic
for the next instance on the Monday prior to the next meeting.

Our next Linux MM Alignment Session is scheduled for Wednesday.  The
details:

Wednesday, November 11 * 9:00 - 10:00am PST (UTC-8)
https://meet.google.com/csb-wcds-xya
backup: https://tel.meet/csb-wcds-xya?pin=1301132214803
doc:
https://docs.google.com/document/d/1QQfZFPHa-pGEGf4A06cSqS0jdJwuZ8ro9JU5H0YSUQ0/view

This week's topic will be Private Nodes and Compressed RAM (CRAM) led by 
Gregory Price.

If anybody has ideas for future topics, please let me know and I'll try to 
organize them.  We'd love to have volunteers to lead future topics as well 
as requests for MM topics to be presented.

Looking forward to seeing all of you on Wednesday!

Time zones

PST (UTC-8)		9:00am
MST (UTC-7)		10:00am
CST (UTC-6)		11:00am
EST (UTC-5)		12:00pm
Rio de Janeiro (UTC-3)	2:00pm
London (UTC)		5:00pm
Berlin (UTC+1)		6:00pm
Moscow (UTC+3)		8:00pm
Dubai (UTC+4)		9:00pm
Mumbai (UTC+5:30)	10:30pm
Singapore (UTC+8)	1:00am Thursday
Beijing (UTC+8)		1:00am Thursday
Tokyo (UTC+9)		2:00am Thursday
Sydney (UTC+11)		4:00am Thursday
Auckland (UTC+13)	6:00am Thursday
