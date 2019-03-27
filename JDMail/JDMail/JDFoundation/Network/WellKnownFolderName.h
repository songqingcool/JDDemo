

//
//  WellKnownFolderName.h
//  JDMail
//
//  Created by 千阳 on 2019/2/20.
//  Copyright © 2019 公司. All rights reserved.
//

#ifndef WellKnownFolderName_h
#define WellKnownFolderName_h

typedef enum : NSUInteger {
    ///The Calendar folder.
    Calendar,
    /// The Contacts folder.
    Contacts,
    // The Deleted Items folder
    DeletedItems,
    // The Drafts folder.
    Drafts,
    // The Inbox folder.
    Inbox,
    // The Journal folder.
    Journal,
    // The Notes folder.
    Notes,
    // The Outbox folder.
    Outbox,
    // The Sent Items folder.
    SentItems,
    // The Tasks folder.
    Tasks,
    // The message folder root.
    MsgFolderRoot,
    // The root of the Public Folders hierarchy.
    /**
     * The Public folder root.
     */
    //@RequiredServerVersion(version = ExchangeVersion.Exchange2007_SP1)
    PublicFoldersRoot,
    // The root of the mailbox.
    Root,
    // The Junk E-mail folder.
    JunkEmail,
    // The Search Folders folder, also known as the Finder folder.
    /**
     */
    //The Search folder.
    SearchFolders,
    // The Voicemail folder.
    /**
     * The Voice mail.
     */
    VoiceMail,
    /**
     * The Dumpster 2.0 root folder.
     */
    //@RequiredServerVersion(version = ExchangeVersion.Exchange2010_SP1)
    RecoverableItemsRoot,
    /*** The Dumpster 2.0 soft deletions folder.
     */
    //@RequiredServerVersion(version = ExchangeVersion.Exchange2010_SP1)
    RecoverableItemsDeletions,
    /**
     * The Dumpster 2.0 versions folder.
     */
    //@RequiredServerVersion(version = ExchangeVersion.Exchange2010_SP1)
    RecoverableItemsVersions,
    /**
     * The Dumpster 2.0 hard deletions folder.
     */
    //@RequiredServerVersion(version = ExchangeVersion.Exchange2010_SP1)
    RecoverableItemsPurges,
    /**
     * The root of the archive mailbox.
     */
    //@RequiredServerVersion(version = ExchangeVersion.Exchange2010_SP1)
    ArchiveRoot,
    /**
     * The message folder root in the archive mailbox.
     */
    //@RequiredServerVersion(version = ExchangeVersion.Exchange2010_SP1)
    ArchiveMsgFolderRoot,
    /**
     * The Deleted Items folder in the archive mailbox.
     */
    //@RequiredServerVersion(version = ExchangeVersion.Exchange2010_SP1)
    ArchiveDeletedItems,
    /**
     * The Dumpster 2.0 root folder in the archive mailbox.
     */
    //@RequiredServerVersion(version = ExchangeVersion.Exchange2010_SP1)
    ArchiveRecoverableItemsRoot,
    /**
     * The Dumpster 2.0 soft deletions folder in the archive mailbox.
     */
    //@RequiredServerVersion(version = ExchangeVersion.Exchange2010_SP1)
    ArchiveRecoverableItemsDeletions,
    /**
     * The Dumpster 2.0 versions folder in the archive mailbox.
     */
    // @RequiredServerVersion(version = ExchangeVersion.Exchange2010_SP1)
    ArchiveRecoverableItemsVersions,
    /**
     * The Dumpster 2.0 hard deletions folder in the archive mailbox.
     */
    //@RequiredServerVersion(version = ExchangeVersion.Exchange2010_SP1)
    ArchiveRecoverableItemsPurges,
} FolderNameType;


#endif /* WellKnownFolderName_h */
