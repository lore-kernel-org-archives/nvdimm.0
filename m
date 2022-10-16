Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0C110E1
	for <nvdimm@lists.linux.dev>; Sun, 16 Oct 2022 14:02:12 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id o17-20020a17090aac1100b0020d98b0c0f4so10636818pjq.4
        for <nvdimm@lists.linux.dev>; Sun, 16 Oct 2022 07:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZfkPplb8D2NrLKR4q22h9cBl2jGfdNbEU+agcABUul8=;
        b=XXqAgjhcktJ9kEEYLa29mkTNZGXdgyCiK4TjwwNg7Ah4/gwkeG4YbTK0pbGxrN1uec
         wISM3SzfApdQPLhiCy4Z5lR8joZRZBr/eiohnrqo0zC957EtDPmSeYOxpcfBKWQFki8Z
         5uQzF2HtVa0ygqL0ZKvOd9SclWjDbJjr/hViQtHTuHLvEBv7ileuxhbksB1j++4zazFQ
         8gCtEdzvmeUHCLf+NtAH2yIWc8XvgaXcS6bCwwvNNsYcqm7MfSSlLqZdSxkWJsrx2juC
         Y6UJEzi8MgQIPtGBfelEI2XnZJNLUoc8gYc3Lzdp3EdW8qJusD7qo6fR0Qwjv3951xTJ
         7QdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZfkPplb8D2NrLKR4q22h9cBl2jGfdNbEU+agcABUul8=;
        b=569e2DZqK2J9Hz3DhSTUzINpQA1NROT4F2/ze9DpAjWr7IBtRxMzDbJb0aINPMHELK
         CkHABJeXtzO/B4Xl78yFNnRrwb8IHS2vqM7MLGoQxZoog/5FKQpBQhpqVVzos32eaQP0
         GtCOOv8QroqVoF7jYm1ew9NYQJ8kyxp0QfM5cIoJoZz7B0GM/JMD6t73zjBfybmHDYhU
         XFHIfTSbf8mCfSdNeOcuvJPTdbxI8X9i3MmiAwk1mzxi4hWBiy0bP4J1uF3CPskMhF/L
         TXR9bxpA9rQNO9KZ1rlti8jwjFou8THYJvi8JKOQLJB0gpsQJ2K3zf8ktMxIZSZgWDxO
         gE4A==
X-Gm-Message-State: ACrzQf1U+BUXTSoLMqrlTwtRGLzzhXdP4TJONo8O9RfWa08AG69SUQgM
	m/alKRZfyBQFvapvBb84nAshPPptG+DIAw==
X-Google-Smtp-Source: AMsMyM6rKvIDpMpIqYm1JWvcBPVTGp20s+0YKZpvIN2i7x6rEqdRo6ErbOUIarnuQJH2ikPnhgBzNg==
X-Received: by 2002:a17:903:1d0:b0:178:1d5b:faf8 with SMTP id e16-20020a17090301d000b001781d5bfaf8mr7268337plh.9.1665928931566;
        Sun, 16 Oct 2022 07:02:11 -0700 (PDT)
Received: from [172.20.156.46] ([162.219.34.251])
        by smtp.gmail.com with ESMTPSA id j9-20020a170902da8900b00174f7d10a03sm4860290plx.86.2022.10.16.07.02.10
        for <nvdimm@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Oct 2022 07:02:11 -0700 (PDT)
Message-ID: <32f08e42-6911-6481-8317-bd63d20c47ef@gmail.com>
Date: Sun, 16 Oct 2022 22:02:08 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Content-Language: en-US
To: nvdimm@lists.linux.dev
From: Wang Jianchao <jianchao.wan9@gmail.com>
Subject: Opensource A light-weight nvdimm filesyste pmmapfs
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi list

This is a try on nvdimm filesystem, pmmapfs, which is specific for the case of 
large files (GiBs) + mmap + userland storage engine. We try to provide better
supporting for pud huge page and some other flexible feature for special cases.

https://github.com/kwai/pmmapfs

Most of content below is from the README file, you can refer it if interested.

Block Allocation
================
To try best to support huge page, pmmapfs maintains the blocks in 3 levels,
pud (1G), pmd (2M) and pte (4K). For example, when we allocate a 4K block,
layout changes as following,

            (pud chk id).(pmd chk id).(pte blk id)
            +-----------------------------------------------------+
            | pud level : chk 0, chk1, achk2, chk3                |
            | pmd level : 0                                       |
            | pte level : 0                                       |
            |                  ||                                 |
            |                  \/                                 |
            | (get chk 0 and charge it to pmd level)              |
            | pud level : chk 1, chk 2, chk3                      |
            | pmd level : chk 0   {chk 0.0, chk 0.1 ... chk 0.511}|
            | pte level : 0                                       |
            |                  ||                                 |
            |                  \/                                 |
            | (get chk 0.0 and charge it to pte level)            |
            | pud level : chk 1, chk 2, chk3                      |
            | pmd level : chk 0   {chk 0.1, chk 0.2 ... chk 0.511}|
            | pte level : chk 0.0 {blk 0.0.0 ... blk 0.0.511      |
            |                  ||                                 |
            |                  \/                                 |
            | (get chk blk 0.0.0)                                 |
            | pud level : chk 1, chk 2, chk3                      |
            | pmd level : chk 0   {chk 0.1, chk 0.2 ... chk 0.511}|
            | pte level : chk 0.0 {blk 0.0.1 ... blk 0.0.511      |
            +-----------------------------------------------------+

If we want to allcate a 4K block again, we can get it from pte level
directly. If we allocate a 1G chunk, just need to pick a chunk up from
the pud level directly.

            +-----------------------------------------------------+
            | pud level : chk 1, chk 2, chk3                      |
            | pmd level : chk 0.1, chk 0.2 ... chk 0.511          |
            | pte level : blk 0.0.1, chk 0.0.2 ... chk 0.0.511    |
            |                 ||                                  |
            |                 \/                                  |
            | (get chk 0)                                         |
            | pud level : chk 2, chk3                             |
            | pmd level : chk 0   {chk 0.1, chk 0.2 ... chk 0.511}|
            | pte level : chk 0.1 {blk 0.0.1 ... blk 0.0.511      |
            +-----------------------------------------------------+

To allocate a full chunk, we need to __TRUNCATE__ the file before we
access it. We don't support pre-allocation when append write, because
it will break the full chunks and introduce fragments.

The freeing of block is similar but reverse. When a chunk is filled
full, it will be freed to uppper level to construct bigger full chunk.

Durability
==========
Pmmapfs is a low-weight filesystem and developped from tmpfs + dax,
durability is a later addition and configurable. So a specific method
to support durablity is taken, full fs metadata snapshot + intend log.

Full fs metadata contains all of information of inodes, bmap, dentries and
symbol link and is loaded when mount to reconstruct the fs. And oberviously
it is not sensible to do full sync every time when the metadata is modified.
So the intend log is introduced to record the modification to very specific
inode. When log area is full, a full sync is triggered and the previous log
is discarded.

   full fs meta          intend long               view after mount
    +--------+     +-------------------------+        +--------+
    | file_a |     | unlink file_a           |        | file_d |
    | file_b |  +  | rename file_b to file_d |    =   | dir_c  |
    | dir_c  |     | create file_e           |        | file_e |
    +--------+     +-------------------------+        +--------+

We have two places to carry the fs metadata to avoid skew up the metadata
if system crash during sync process.

       +---------+   +-----+              +---------+
   =>  | fs meta | + | log |              | fs meta |
       +---------+   +-----+    SYNC      +---------+
       +---------+                        +---------+
       | fs meta |                     => | fs meta |
       +---------+                        +---------+         

Right now, we have two kinds of metadata snapshot + intend log
 - filesystem
   carry the metadata of the filesystem and is stored in special
   files in .admin directory
   .admin/
   ├── f64c1c05ac710417
   │   ├── 0
   │   ├── 1
   │   ├── 2
   │   ├── 3
   │   ├── 4
   │   ├── 5
   │   ├── 6
   │   └── 7
   └── f64c1c05ac710418
       ├── 0
       ├── 1
       ├── 2
       ├── 3
       ├── 4
       ├── 5
       ├── 6
       └── 7
   (multiple metadata files is for multiple-thread sync)
 - admin
   carry the metadata of the special files above and is stored in
   reserved space

        admin   admin   admin
    sb0  log    meta0   meta1    sb1     fs log
   |--||-----||-------||-------||--||||------------||
   \________________ _________________/
                    v
                 meta_len
 

And you may have found it, when durablity is enabled, pmmapfs is not good at
massive small files and metadata sensitive cases. The full sync of metadata
will become a disaster. As we said in the beginning, pmmapfs is specific for
the case large files (GiBs) + mmap + userland storage engine. In tis case,
there will not be too many files and most of the file are composed of 1G/2M
chunks. The amount of metadata is relatively small.

Mount:
======
There are two critical steps during mount,

(1) LOAD:
Load the metadata of
 - regular files and their bmaps
 - directory files and their dentries
 - symlink files and their symbol

When a file's inode is loaded before its parent, don't know its dentry, so
we construct a dentry with inode number as name and lost+found as parent.
When the file's parent is loaded and we get its dentry, move the inode back.

When a file's parent is loaded before its inode, we create an empty inode.
When we get the metadata of file's inode, fill the empty inode with it.
When the load step complete, the empty inodes will be discarded.

The load process could be deemed as fsck. crc32 is checked for every metadata
page and corrupted ones will be get rid of. In lost+found, we can find the
files and directories that lose their parent. After adapt them manually, trigger
a full sync with 'echo 1 > /sys/fs/pmmap/pmemX/sync' will repair the tree.

(2) REPLAY
The intend log replay is relatively simple. Just one thing need to be noted,
when the log is courrpted, we will continue the replay process. This may cause
issue such as, blocks that need to be reserved cannot be freed by skipped
corrupted log. But we should replay the log as much as possible.


Thanks
Jianchao
